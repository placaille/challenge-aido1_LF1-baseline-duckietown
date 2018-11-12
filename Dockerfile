# Definition of Submission container

# We start from the AIDO1_LF1 ROS template
FROM duckietown/challenge-aido1_lf1-template-ros:v3

RUN ["cross-build-start"]

# let's copy all our solution files to our workspace
# if you have more file use the COPY command to move them to the workspace
COPY solution.py ./

# For ROS Agent - Additional Files
COPY rosagent.py ./
COPY lf_slim.launch ./

## Uncomment these to build your own catkin_ws
#### START CUSTOM CATKIN_WS ####

RUN /bin/bash -c "mkdir -p custom_ws/src/"

## Copy or init your packages in here

# line detector package
COPY aido-challenge-custom_code/dolores_line_detector custom_ws/src/dolores_line_detector
RUN chmod +x custom_ws/src/dolores_line_detector/src/line_detector_node.py

# lane filter package
COPY aido-challenge-custom_code/dolores_lane_filter custom_ws/src/dolores_lane_filter
RUN chmod +x custom_ws/src/dolores_lane_filter/src/lane_filter_node.py

# lane control package
COPY aido-challenge-custom_code/dolores_lane_control custom_ws/src/dolores_lane_control
RUN chmod +x custom_ws/src/dolores_lane_control/scripts/lane_controller_node.py

## Do not change the below line! This ensures that your workspace is overlayed on top of the Duckietown stack!
## MAKE sure this line is present in the build: This workspace overlays: /home/software/catkin_ws/devel;/opt/ros/kinetic
RUN /bin/bash -c "source /home/software/catkin_ws/devel/setup.bash && catkin_init_workspace && cd ../.."
RUN /bin/bash -c "source /home/software/catkin_ws/devel/setup.bash && catkin_make -j -C custom_ws/"
RUN echo "source custom_ws/devel/setup.bash" >> ~/.bashrc

#### END CUSTOM CATKIN_WS ####

# DO NOT MODIFY: your submission won't run if you do
ENV DUCKIETOWN_SERVER=evaluator

RUN ["cross-build-end"]
ENTRYPOINT ["qemu3-arm-static"]

# let's see what you've got there...
CMD ["/bin/bash", "-ci", "./solution.py"]
