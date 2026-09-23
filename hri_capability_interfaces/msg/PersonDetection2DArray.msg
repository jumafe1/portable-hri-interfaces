# Time and optional source-frame identifier of the processed image.
std_msgs/Header header
# All valid people detected in this frame; an empty array is a valid no-person result.
hri_capability_interfaces/PersonDetection2D[] people
# Provider that normalized this frame, for traceability without provider-specific types.
string provider
