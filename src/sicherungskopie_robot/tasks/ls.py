import subprocess
import os


def ls():
    #duplicity list-current-files b2://${B2_ACCOUNT}:${B2_KEY}@${B2_BUCKET}/${B2_DIR}
    subprocess.run(['duplicity', 'list-current-files', 'b2://abcc93aa2562:000730a23107771a98d6b77c3bcddec912d3e2a2ed@GreenFolder/Proyects' ], shell=False)
    print('Hola desde ls')
