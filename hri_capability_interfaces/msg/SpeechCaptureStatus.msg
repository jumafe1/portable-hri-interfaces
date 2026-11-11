# Periodic liveness/status of an admitted continuous capture, no audio or text.
std_msgs/Header header
string request_id
string provider
# listening, speech, processing, or speech_and_processing
string state
uint32 queued_segments
uint64 dropped_segments
