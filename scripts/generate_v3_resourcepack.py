import csv


def generate_multimodel(csv_mappings_file, model_name, durability: int, model=None) -> dict:
    """
    Generates

    :param csv_mappings_file: name of the CSV-file containing required mapping
    :param model_name: name of the original model
    :param durability: durability of the item used for specific model generation
    :param model: basic model data, by default it will be filled with standard parent and textures
    :return created model
    """

    if model is None:
        model = {
            'parent': 'item/handheld',
            'textures': ['layer0', f'items/${model_name}']
        }

    with open(csv_mappings_file) as csv_mappings_file:
        mappings = csv.reader(csv_mappings_file)
        next(mappings, None)

        overrides = [{'predicate': {'damage': 0}, 'model': f'item/${model_name}'}]
        for mapping in mappings:
            overrides.append({
                'predicate': {'damaged': 0, 'damage': int(mapping[0]) / durability},
                'model': mapping[1]
            })
        model['overrides'] = overrides

    return model
