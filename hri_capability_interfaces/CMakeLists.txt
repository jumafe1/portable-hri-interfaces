cmake_minimum_required(VERSION 3.16)
project(hri_capability_interfaces)

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/PersonDetection2D.msg"
  "msg/PersonDetection2DArray.msg"
  "srv/DetectPeople.srv"
  "srv/MoveRelative.srv"
  "srv/Speak.srv"
  DEPENDENCIES std_msgs
)

install(
  DIRECTORY capability_interfaces
  DESTINATION share/${PROJECT_NAME}
)

ament_export_dependencies(rosidl_default_runtime)
ament_package()
