require 'gps2'
require 'pp'

$banana_ops = [
              GPS2::op(:climb_on_chair, 
                       :preconds => [:chair_at_middle_room, :at_middle_room, :on_floor],
                       :add_list => [:at_bananas, :on_chair],
                       :del_list => [:at_middle_room, :on_floor]),
              GPS2::op(:push_chair_from_door_to_middle_room, 
                       :preconds => [:chair_at_door, :at_door],
                       :add_list => [:chair_at_middle_room, :at_middle_room],
                       :del_list => [:chair_at_door, :at_door]),
              GPS2::op(:walk_from_door_to_middle_room, 
                       :preconds => [:at_door, :on_floor],
                       :add_list => [:at_middle_room],
                       :del_list => [:at_door]),
              GPS2::op(:grasp_bananas, 
                       :preconds => [:at_bananas, :empty_handed],
                       :add_list => [:has_bananas],
                       :del_list => [:empty_handed]),
              GPS2::op(:drop_ball, 
                       :preconds => [:has_ball],
                       :add_list => [:empty_handed],
                       :del_list => [:has_ball]),
              GPS2::op(:eat_bananas, 
                       :preconds => [:has_bananas],
                       :add_list => [:empty_handed, :not_hungry],
                       :del_list => [:has_bananas, :hungry])
             ]

gps = GPS2.new([:at_door, :on_floor, :has_ball, :hungry, :chair_at_door],
               $banana_ops)
pp gps.solve(:not_hungry)
