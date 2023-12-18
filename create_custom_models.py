from pathlib import Path
from tdw.asset_bundle_creator.model_creator import ModelCreator
from tdw.backend.paths import EXAMPLE_CONTROLLER_OUTPUT_PATH
import os


current_dir = "/Users/cfang/balls/"
# current_dir = os.path.dirname(os.path.dirname(os.getcwd()))
print(current_dir)
objs_dir = os.path.join(current_dir, "OBJs")
output_directory = os.path.join(current_dir, "TDW_objects")
# output_directory = EXAMPLE_CONTROLLER_OUTPUT_PATH.joinpath("local_object")
# print(f"Asset bundles will be saved to: {output_directory}")
# ModelCreator().source_file_to_asset_bundles(name="ramp",
#                                             source_file=Path(os.path.join(objs_dir, 'ramp.obj')).resolve(),
#                                             output_directory=output_directory)


obj_names = os.listdir(objs_dir)

if not os.path.exists(output_directory):
    os.mkdir(output_directory)

for object_name in obj_names:
    if ".obj" in object_name:
        print(object_name)
        object = object_name.split(".")[0]
        ModelCreator().source_file_to_asset_bundles(
            name=object,
            source_file=Path(os.path.join(objs_dir, object_name)).resolve(),
            output_directory=output_directory,
            library_path=os.path.join(output_directory, "library.json"),
            library_description="Centered Objs",
            internal_materials=False,
            cleanup=True,
            # validate=True,
        )


# from tdw.asset_bundle_creator.model_creator import ModelCreator
# from tdw.backend.paths import EXAMPLE_CONTROLLER_OUTPUT_PATH

# output_directory = EXAMPLE_CONTROLLER_OUTPUT_PATH.joinpath("local_object")
# print(f"Asset bundles will be saved to: {output_directory}")
# ModelCreator().source_file_to_asset_bundles(name="ramp",
#                                             source_file="blender/ramp.obj",
#                                             output_directory=output_directory)