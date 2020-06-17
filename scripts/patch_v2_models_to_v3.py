import json
import os

import click

# see: https://minecraft.gamepedia.com/Model
ALLOWED_MODEL_ROOT_TAGS = {
    'parent', 'ambientocclusion', 'display', 'textures', 'elements', 'gui_light', 'overrides'
}


def patch_v2_models_to_v3(models_directory):
    for parent, directories, files in os.walk(models_directory):
        for file in files:
            if not file.endswith('.json'):
                continue

            file = os.path.join(parent, file)
            with open(file, 'r+') as model_file:
                model = json.load(model_file)
                model_file.seek(0)

                # Patches start
                textures = model['textures']

                dirty = False
                if textures is not None:
                    for (key, value) in list(textures.items()):
                        texture_dirty = False  # Flag indicating if changes happened

                        # 1) remove explicit `minecraft:` namespace
                        if value.startswith('minecraft:'):
                            value = value[10:]
                            texture_dirty = True

                        # 2) replace `blocks/` and `items/` with `block/` and `item/` respectively
                        if value.startswith('blocks/'):
                            value = f'block/{value[7:]}'
                            texture_dirty = True
                        elif value.startswith('items/'):
                            value = f'item/{value[6:]}'
                            texture_dirty = True

                        if texture_dirty:
                            textures[key] = value
                            dirty = True  # At least one change happened
                # Patches end

                if dirty:
                    json.dump(model, model_file, separators=(',', ':'))
                    model_file.truncate()


@click.command()
@click.option(
    '-m', '--models', 'models_path',
    help='Path to the folder in which all json-models should be updated from V2 to V3',
    type=click.Path(file_okay=False, writable=True)
)
def main(models_path):
    patch_v2_models_to_v3(models_path)


if __name__ == '__main__':
    main()
