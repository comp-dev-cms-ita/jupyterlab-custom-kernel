import pathlib
import json


from jupyterlab.labapp import LabApp


from .handlers import setup_handlers


HERE = pathlib.Path(__file__).parent.resolve()

with open(HERE / 'labextension' / 'package.json') as fid:
    data = json.load(fid)

def _jupyter_labextension_paths():
    return [{
        'src': 'labextension',
        'dest': data['name']
        }]

def _jupyter_server_extension_paths():
    return [{
        "module": "ksmm.app",
        "app": ksmm
    }]

def _jupyter_server_extension_points():
    return [{"module": "ksmm"}]

def _load_jupyter_server_extension(server_app: LabApp):
    setup_handlers(server_app)
    
