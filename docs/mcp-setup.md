# Godot MCP setup

This task used the Coding-Solo/godot-mcp local stdio MCP server, built from its upstream repository, with the official installed Godot executable:

- Server: `../../.tools/godot-mcp/build/index.js` relative to this document's folder.
- Godot: `/Users/abinashbasak/Downloads/Godot_mono.app/Contents/MacOS/Godot`
- Detected version: `4.7.2.stable.mono.official.ed1daf0bf`
- Upstream: https://github.com/Coding-Solo/godot-mcp

The current assistant session did not expose Godot as a built-in MCP tool. A local MCP SDK client connected to this server over stdio and called its real tools: `get_godot_version`, `get_project_info`, `create_scene`, `add_node`, `run_project`, `get_debug_output`, `stop_project`, and `launch_editor`.

From the parent `lantrns/` directory, a sample read-only call is:

```sh
node .tools/godot-mcp/client.mjs '[{"name":"get_godot_version"}]'
```

To configure this server in an MCP client, use command `node`, argument `/Users/abinashbasak/Desktop/games/lantrns/.tools/godot-mcp/build/index.js`, and environment variable `GODOT_PATH` set to the executable above. No global Codex or browser settings were changed. The game's runtime has no dependency on Node.js or the MCP server.

`mcp-scene-setup.json` records scene creation; `mcp-validation.json` records the final project launch/debug/stop verification.
