FROM hypothe/sciroc:pplperc-hri-logic-objdet-devel

WORKDIR ${REPO_WS}/src
RUN git clone https://github.com/hypothe/sciroc_meta.git -b yolov5


WORKDIR  ${REPO_WS}
RUN source ${HOME}/.bashrc \
    && source /opt/pal/ferrum/setup.bash \
    && source devel/setup.bash \
    && catkin build -DDISABLE_PAL_FLAGS=True -DCMAKE_BUILD_TYPE=Release

ENTRYPOINT ["bash"]