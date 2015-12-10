package {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;

	public class MyWorker extends Sprite
	{

		private var _workerToMain:MessageChannel;
		private var _mainToWorker:MessageChannel;

		public function MyWorker()
		{
			_mainToWorker = Worker.current.getSharedProperty("mainToBack");
			_mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToWorker);

			_workerToMain = Worker.current.getSharedProperty("backToMain");
			_workerToMain.send("--WORKER STARTED--")
		}
		
		private function onMainToWorker(event:Event):void
		{
			var value:int = _mainToWorker.receive();
			_workerToMain.send(value * 2);
		}
	}
}
