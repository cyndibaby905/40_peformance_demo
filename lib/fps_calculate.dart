import 'dart:ui';


//原始FPS回调
var orginalCallback;

const maxframes = 25;
final lastFrames = List<FrameTiming>();
const frameInterval = const Duration(microseconds: Duration.microsecondsPerSecond ~/ 60);

void onReportTimings(List<FrameTiming> timings) {

  lastFrames.addAll(timings);
  if(lastFrames.length > maxframes) {
    lastFrames.removeRange(0, lastFrames.length - maxframes);
  }

  if (orginalCallback != null) {
    orginalCallback(timings);
  }
  print("fps : $fps");
}


double get fps {
  int sum = 0;
  for (FrameTiming timing in lastFrames) {

    int duration = timing.timestampInMicroseconds(FramePhase.rasterFinish) - timing.timestampInMicroseconds(FramePhase.buildStart);
    if(duration < frameInterval.inMicroseconds) {
      sum += 1;
    } else {
      int count = (duration/frameInterval.inMicroseconds).ceil();
      sum += count;
    }
  }
  return lastFrames.length/sum * 60;

}
