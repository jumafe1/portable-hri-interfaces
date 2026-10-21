# Stamp of measured orientation, not of status publication.
std_msgs/Header header
# Neutral-relative mount angles (radians); elevation positive upward.
float64 elevation
float64 azimuth
bool ready
# True until fresh feedback has settled at the requested pose.
bool moving
string provider
string status
