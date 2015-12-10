package {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;

	public class Main extends Sprite
	{
		[Embed(source="../../../bin/MyWorker.swf", mimeType="application/octet-stream")]
		private static var BgWorker_ByteClasss:Class;

		private var _worker:Worker;

		private var _workerToMain:MessageChannel;
		private var _mainToWorker:MessageChannel;


		public function Main() {

			var workerBytes:ByteArray = new BgWorker_ByteClasss();
			_worker = WorkerDomain.current.createWorker(workerBytes);

			_mainToWorker = Worker.current.createMessageChannel(_worker);
			_worker.setSharedProperty("mainToBack", _mainToWorker);

			_workerToMain = _worker.createMessageChannel(Worker.current);
			_workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onBackToMain, false, 0, true);
			_worker.setSharedProperty("backToMain", _workerToMain);

			_worker.addEventListener(Event.WORKER_STATE, workerStateHandler);
			_worker.start();
		}

		private function onBackToMain(event:Event):void
		{
			var reply:int = _workerToMain.receive()
			if (reply == 84)
			{
				this.graphics.beginFill(0xff0000);
				this.graphics.drawCircle(100,100,50);
				this.graphics.endFill();
			}
		}

		private function workerStateHandler(event:Event):void
		{
			trace("WorkerState: " + _worker.state);

			if (_worker.state == WorkerState.RUNNING)
			{
				_mainToWorker.send(42);
			}
		}
	}
}
