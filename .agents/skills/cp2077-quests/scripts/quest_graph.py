"""Read a regular WolvenKit CR2W quest export. Resolve identity before following edges."""
import argparse
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path


def objects(root):
    pending = [root]
    while pending:
        value = pending.pop()
        if isinstance(value, dict):
            yield value
            pending.extend(reversed(value.values()))
        elif isinstance(value, list):
            pending.extend(reversed(value))


def key(ref):
    return str(ref["HandleId"] if "HandleId" in ref else ref["HandleRefId"])


def scalar(value):
    return value.get("$value", value) if isinstance(value, dict) else value


def inspect(document, show_edges, show_sockets):
    root = document["Data"]["RootChunk"]
    if root["$type"] not in ("questQuestResource", "questQuestPhaseResource"):
        raise ValueError(f"expected .quest or .questphase, got {root['$type']}")
    table = {}
    for item in objects(root):
        if "HandleId" in item:
            identity = key(item)
            if identity in table:
                raise ValueError(f"duplicate handle definition {identity}")
            table[identity] = item["Data"]
        elif "HandleRefId" in item and key(item) != "-1" and key(item) not in table:
            raise ValueError(f"handle {key(item)} referenced before definition")

    pending = [("root", key(root["graph"]))]
    visited = set()
    while pending:
        scope, graph = pending.pop()
        if graph in visited:
            continue
        visited.add(graph)
        print(f"[{scope}] graph handle {graph}")
        sockets = {}
        mentions = defaultdict(list)
        node_ids = set()
        for ref in table[graph]["nodes"]:
            node = table[key(ref)]
            nid = node["id"]
            if nid in node_ids:
                raise ValueError(f"{scope}: duplicate node id {nid}")
            node_ids.add(nid)
            attrs = []
            for field in ("socketName", "phaseResource", "sceneFile"):
                if field in node:
                    value = node[field]
                    if isinstance(value, dict):
                        if value.get("Flags") == "Embedded":
                            attrs.append(f"{field}.Flags=Embedded")
                        value = value.get("DepotPath", value)
                    attrs.append(f"{field}={scalar(value)}")
            for field in ("condition", "type"):
                value = node.get(field)
                if isinstance(value, dict) and ("HandleId" in value or "HandleRefId" in value):
                    payload = table[key(value)]
                    attrs.append(payload["$type"])
                    detail = payload.get("type")
                    if isinstance(detail, dict) and ("HandleId" in detail or "HandleRefId" in detail):
                        attrs.append(table[key(detail)]["$type"])
            print(f"  {nid} {node['$type']} {' '.join(attrs)}".rstrip())
            if node.get("phaseGraph"):
                pending.append((f"{scope}/{nid}", key(node["phaseGraph"])))
            for wrapper in node["sockets"]:
                sid = key(wrapper)
                sock = table[sid]
                if sid in sockets:
                    raise ValueError(f"{scope}: socket {sid} listed twice")
                sockets[sid] = f"{nid}.{scalar(sock['name'])}"
                if show_sockets:
                    print(f"    {sockets[sid]} ({sock['type']}, handle {sid})")
                for conn in sock["connections"]:
                    mentions[key(conn)].append(sid)
        for cid, refs in mentions.items():
            conn = table[cid]
            for endpoint in ("source", "destination"):
                ref = conn.get(endpoint)
                if not isinstance(ref, dict) or key(ref) not in sockets:
                    raise ValueError(f"{scope}: edge {cid} has missing or non-local {endpoint}: {ref}, listed by {refs}")
            source, dest = key(conn["source"]), key(conn["destination"])
            if conn["$type"] != "graphGraphConnectionDefinition" or Counter(refs) != Counter([source, dest]):
                raise ValueError(f"{scope}: edge {cid} endpoints {source}->{dest}, listed by {refs}")
            pair = (table[source]["type"], table[dest]["type"])
            if pair not in (("Output", "Input"), ("CutSource", "CutDestination")):
                raise ValueError(f"{scope}: check direction of edge {cid}: {pair}")
            if show_edges:
                print(f"    {sockets[source]} -> {sockets[dest]} (edge {cid})")
        print(f"  {len(node_ids)} nodes, {len(sockets)} sockets, {len(mentions)} edges")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", type=Path)
    parser.add_argument("--edges", action="store_true", help="print directed edges")
    parser.add_argument("--sockets", action="store_true", help="include disconnected sockets")
    args = parser.parse_args()
    try:
        with args.file.open(encoding="utf-8-sig") as stream:
            inspect(json.load(stream), args.edges, args.sockets)
    except (OSError, ValueError, KeyError, TypeError, RecursionError) as error:
        print(f"{args.file}: invalid or unsupported export ({error})", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
