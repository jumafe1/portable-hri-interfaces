# Timestamp/frame of captured audio, not of inference completion.
std_msgs/Header header
string request_id
string provider
string text
string language
bool success
string message
# 0 for a single window or terminal stream error; positive for stream segments.
uint64 segment_index
# True ends the request. Continuous segment results have final=false.
bool final
