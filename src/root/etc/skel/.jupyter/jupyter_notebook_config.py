import os

c.ServerApp.allow_root = True
c.ServerApp.ip = "0.0.0.0"
c.ServerApp.port = int(os.getenv("JUPYTER_PORT", "8888"))
c.ServerApp.custom_display_url = "http://hostname:%d" % (c.ServerApp.port)
c.ServerApp.open_browser = False
c.ServerApp.terminado_settings = {"shell_command": ["/bin/bash", "-i"]}
c.ServerApp.contents_manager_class = "jupytext.TextFileContentsManager"
c.Completer.use_jedi = False
c.ContentsManager.allow_hidden = True
c.LabApp.code_formatter = {
    "black": {
        "enable": True
    }
}
c.ServerApp.root_dir = os.getenv("HOME", "/home")