import csv
import json


def generate_item_model_file(csv_mappings_file, target_file, model_name, durability: int, textures=None):
    if textures is None:
        textures = ['layer0', f'items/${model_name}']

    with open(csv_mappings_file) as csv_mappings_file:
        mappings = csv.reader(csv_mappings_file)
        next(mappings, None)

        model = {
            'parent': 'item/handheld',
            'textures': textures
        }

        overrides = [{'predicate': {'damage': 0}, 'model': f'item/${model_name}'}]
        for mapping in mappings:
            overrides.append({
                'predicate': {'damaged': 0, 'damage': int(mapping[0]) / durability},
                'model': mapping[1]
            })
        model['overrides'] = overrides

    with open(target_file, 'w') as target_file:
        json.dump(model, target_file)
