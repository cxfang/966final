import numpy as np

from tdw.controller import Controller
from tdw.tdw_utils import TDWUtils
from tdw.librarian import ModelLibrarian, MaterialLibrarian
from tdw.add_ons.object_manager import ObjectManager
from tdw.add_ons.collision_manager import CollisionManager
from tdw.add_ons.third_person_camera import ThirdPersonCamera
from tdw.add_ons.image_capture import ImageCapture
import os
from tdw.output_data import OutputData, Bounds
from pathlib import Path


def run_sim(
    friction, velocity, surface_color, collider_mode, room="empty_room", invisible=False
):
    c = Controller()
    screen_width = 1200
    screen_height = 500
    c.communicate(
        {"$type": "set_screen_size", "width": screen_width, "height": screen_height}
    )

    if room == "empty_room":
        c.communicate(TDWUtils.create_empty_room(30, 50))
    elif room == "tdw_room":
        c.communicate(Controller.get_add_scene(scene_name="tdw_room"))
    elif room == "nothing":
        c.communicate(Controller.get_add_scene(scene_name="empty_scene"))

    #######
    user = "aryan"

    dev = False

    slider = True

    video_capture = False

    collider = True

    plane_position = {"x": 0, "y": 0.0441, "z": -7.3}
    surf2_position = {"x": 0, "y": 0.0, "z": -5.8}
    #######

    if user == "aryan":
        current_dir = "C:\\Users\\aryan\cyn\\friction_pilot\\"
    else:
        current_dir = "/Users/cfang/balls/"
    # Add a camera and an object manager.
    if dev:
        camera = ThirdPersonCamera(
            position={"x": 1.5, "y": 0.5, "z": -1},
            look_at={"x": 0, "y": 0.05, "z": -1},
            field_of_view=100,
        )  # 85)
        # camera = ThirdPersonCamera(position={"x": 0.1, "y": 3.0, "z": 0},
        #                         look_at={"x": 0, "y": 0.1, "z": 0},
        #                         field_of_view=120)
        # camera = ThirdPersonCamera(position={"x": 4.0, "y": 8.0, "z": 2.0},
        #                         look_at={"x": 0, "y": 0.2, "z": 2.0},
        #                         field_of_view=80)
    else:
        camera = ThirdPersonCamera(
            position={"x": 2.8, "y": 0.9, "z": 0.4},
            look_at={"x": 0, "y": 0.05, "z": 0.4},
            field_of_view=100,
        )  # 85)

        # position = TDWUtils.get_expected_window_position(window_width=screen_width, window_height=screen_height)

    object_manager = ObjectManager(transforms=True, rigidbodies=True)
    collision_manager = CollisionManager(
        enter=True, stay=False, exit=False, objects=True, environment=True
    )
    commands = [{"$type": "set_focus_distance", "focus_distance": 8.0}]

    if video_capture:
        path = os.path.join(current_dir, "video_capture")
        print(f"Video will be saved to: {path}")
        capture = ImageCapture(path=path, avatar_ids=["test"])
        # c.add_ons.append(capture)
        c.communicate({"$type": "set_target_framerate", "framerate": 60})
        c.add_ons.extend([camera, capture, object_manager, collision_manager])
    else:
        c.add_ons.extend([camera, object_manager, collision_manager])

    slider_id = 11730513
    surface2_id = 3403213
    collider_id = 2749034
    plane_id = 10116127
    # occluder_id = c.get_unique_id()

    librarian = ModelLibrarian(
        library=os.path.join(current_dir, "TDW_objects", "library.json")
    )
    models_directory = (
        os.path.join(current_dir, "TDW_objects", "Darwin").replace("\\", "/") + "/"
    )
    surface_name = "surface3"
    surface_model_record = librarian.get_record(surface_name)

    plane_name = "plane"
    plane_model_record = librarian.get_record(plane_name)

    #####

    if velocity == "fast":
        slider_velocity = {"x": 0, "y": 0, "z": 25}  # fastest
    elif velocity == "med":
        slider_velocity = {"x": 0, "y": 0, "z": 19.5}  # med
    elif velocity == "slow":
        slider_velocity = {"x": 0, "y": 0, "z": 14.0}  # slowest

    if surface_color == "teal":
        surface_rgb = {"r": 80 / 255, "g": 170 / 255, "b": 145 / 255, "a": 0.9}
    elif surface_color == "pink":
        surface_rgb = {"r": 240 / 255, "g": 130 / 255, "b": 180 / 255, "a": 0.9}
    elif surface_color == "purple":
        surface_rgb = {"r": 144 / 255, "g": 133 / 255, "b": 219 / 255, "a": 0.86}
    elif surface_color == "tan":
        surface_rgb = {"r": 179 / 255, "g": 142 / 255, "b": 88 / 255, "a": 0.6}
    elif surface_color == "white":
        surface_rgb = {"r": 255 / 255, "g": 255 / 255, "b": 255 / 255, "a": 1.0}

    slider_position = {"x": 0, "y": 0.0441, "z": -4.0}

    ban_fr_stat = 0.01
    ban_fr_dyn = 0.01

    if friction == "high":
        surf2_fr_dyn = 0.0275
    elif friction == "med":
        surf2_fr_dyn = 0.02
    elif friction == "low":
        surf2_fr_dyn = 0.017

    collider_position = {"x": 0, "y": 0.0441, "z": (-1.5 + 0.3 * (collider_mode - 1))}

    surf1_fr_stat = 0.0
    surf1_fr_dyn = 0.0
    surf2_fr_stat = 0.1

    #####

    # SURFACE 2
    commands.extend(
        [
            {
                "$type": "add_object",
                "name": surface_name,
                "url": "file:///" + models_directory + surface_name,
                "id": surface2_id,
                "rotation": {"x": 0.0, "y": 180.0, "z": 0.0},
                "position": surf2_position,
            },
            {
                "$type": "scale_object",
                "scale_factor": {"x": 0.25, "y": 0.15, "z": 0.8},
                "id": surface2_id,
            },
            {"$type": "set_mass", "mass": 10000, "id": surface2_id},
            {
                "$type": "set_physic_material",
                "dynamic_friction": surf2_fr_dyn,
                "static_friction": surf2_fr_stat,
                "bounciness": 0.0,
                "id": surface2_id,
            },
            {"$type": "set_color", "color": surface_rgb, "id": surface2_id},
        ]
    )
    if invisible:
        commands.extend(
            [{"$type": "set_object_visibility", "id": surface2_id, "visible": False}]
        )
    # PLANE
    commands.extend(
        [
            {
                "$type": "add_object",
                "name": plane_name,
                "url": "file:///" + models_directory + plane_name,
                "id": plane_id,
                "rotation": {"x": 0.0, "y": 180.0, "z": 0.0},
                "position": plane_position,
            },
            {
                "$type": "scale_object",
                "scale_factor": {"x": 0.25, "y": 0.5, "z": 0.25},
                "id": plane_id,
            },
            {"$type": "set_mass", "mass": 10000, "id": plane_id},
            {
                "$type": "set_physic_material",
                "dynamic_friction": surf1_fr_dyn,
                "static_friction": surf1_fr_stat,
                "bounciness": 0.0,
                "id": plane_id,
            },
        ]
    )
    if invisible:
        commands.extend(
            [{"$type": "set_object_visibility", "id": plane_id, "visible": False}]
        )
    commands.extend(
        TDWUtils.set_visual_material(
            c=c,
            substructure=plane_model_record.substructure,
            material="glass_fiber_plain_weave",
            object_id=plane_id,
        )
    )

    box_model_record = ModelLibrarian().get_record("iron_box")
    # #COLLIDING OBJECT
    if collider:
        commands.extend(
            [
                {
                    "$type": "add_object",
                    "name": "iron_box",
                    "url": "https://tdw-public.s3.amazonaws.com/models/linux/2018-2019.1/iron_box",
                    "position": collider_position,
                    "category": "box",
                    "id": collider_id,
                },
                {
                    "$type": "scale_object",
                    "scale_factor": {"x": 1.25, "y": 0.65, "z": 0.65},
                    "id": collider_id,
                },
                {"$type": "set_mass", "mass": 0.1, "id": collider_id},
                {
                    "$type": "set_physic_material",
                    "dynamic_friction": 0.01,
                    "static_friction": 0.01,
                    "bounciness": 0.0,
                    "id": collider_id,
                },
            ]
        )
        commands.extend(
            TDWUtils.set_visual_material(
                c=c,
                substructure=box_model_record.substructure,
                material="concrete",
                object_id=collider_id,
            )
        )
        commands.extend(
            [
                {
                    "$type": "set_color",
                    "color": {"r": 164 / 255, "g": 125 / 255, "b": 87 / 255, "a": 0.64},
                    "id": collider_id,
                }
            ]
        )

    # slider!
    if slider:
        commands.extend(
            [
                {
                    "$type": "add_object",
                    "name": "iron_box",
                    "url": "https://tdw-public.s3.amazonaws.com/models/linux/2018-2019.1/iron_box",
                    "position": slider_position,
                    "category": "box",
                    "id": slider_id,
                },
                {
                    "$type": "scale_object",
                    "scale_factor": {"x": 0.6, "y": 0.6, "z": 0.65},
                    "id": slider_id,
                },
                {
                    "$type": "rotate_object_by",
                    "angle": 90,
                    "id": slider_id,
                    "axis": "yaw",
                    "use_centroid": True,
                },
                {"$type": "set_mass", "mass": 15, "id": slider_id},
                {
                    "$type": "set_physic_material",
                    "dynamic_friction": ban_fr_dyn,
                    "static_friction": ban_fr_stat,
                    "bounciness": 0.0,
                    "id": slider_id,
                },
            ]
        )
        commands.extend(
            TDWUtils.set_visual_material(
                c=c,
                substructure=box_model_record.substructure,
                material="concrete",
                object_id=slider_id,
            )
        )
        commands.extend(
            [
                {
                    "$type": "set_color",
                    "color": {"r": 92 / 255, "g": 92 / 255, "b": 92 / 255, "a": 0.36},
                    "id": slider_id,
                }
            ]
        )

    c.communicate(commands)
    c.communicate(
        [{"$type": "apply_force_to_object", "id": slider_id, "force": slider_velocity}]
    )

    object_names = dict()
    for object_id in object_manager.objects_static:
        object_names[object_id] = object_manager.objects_static[object_id].name

    # Run the simulation until all objects stop moving.
    positions = dict()
    velocities = dict()
    sleeping = False
    while not sleeping:
        sleeping = True
        for object_id in object_manager.rigidbodies:
            if not object_manager.rigidbodies[object_id].sleeping:
                sleeping = False
            # remember the velocity
            if object_id not in velocities:
                velocities[object_id] = list()
            velocities[object_id].append(object_manager.rigidbodies[object_id].velocity)
        # Remember the position
        for object_id in object_manager.transforms:
            if object_id not in positions:
                positions[object_id] = list()
            positions[object_id].append(object_manager.transforms[object_id].position)
        # Advance once frame.
        c.communicate([])
    data = {
        "velocities": velocities,
        "positions": positions,
        "object_names": object_names,
    }

    np.save(
        "box_data/v{}_f{}_c{}_{}.npy".format(
            velocity, friction, collider_mode, surface_color
        ),
        data,
    )

    # Mark the object manager as requiring re-initialization.
    object_manager.initialized = False

    for i in range(20):
        c.communicate([])
    c.communicate({"$type": "terminate"})
