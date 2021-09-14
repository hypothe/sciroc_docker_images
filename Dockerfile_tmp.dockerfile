FROM registry.gitlab.com/competitions4/sciroc/dockers/sciroc:1.5 as pal
FROM ros:noetic-ros-base-focal


COPY --from=pal /opt/pal/ferrum/share/pal_interaction_msgs /opt/ros/noetic/share/pal_interaction_msgs
