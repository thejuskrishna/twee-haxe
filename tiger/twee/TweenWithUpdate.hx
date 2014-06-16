/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee;

class TweenWithUpdate extends Tween{

	public function new(  target:Object, duration:Number, fromVars:Object, toVars:Object, options:Object ){
		super(  target, duration, fromVars, toVars, options );
	}
		
	override public function render(timeDelta:int):void{
		
		var i:int, count:int;
			
		if( _timeElapsed==_duration ){ // So that the callback in called in next frame.
			if( _repeat<=1 ){
				if( _options.onComplete is Function ) _options.onComplete.apply( null, _options.onCompleteParams );
				if(_tailedTwees) for( i=0, count=_tailedTwees.length; i<count; i++ ) _tailedTwees[i].activate();
				destroy();
			}
			else{
				_repeat--;
				_timeElapsed = 0;
				var tmp:Vector.<Number>;
				if( _options.tonfro ) tmp = _toVars, _toVars = _fromVars, _fromVars = tmp;
			}
		}
		else{
			_timeElapsed += timeDelta;
			if( _timeElapsed>_duration ) _timeElapsed=_duration;
			
			for( i=0; i<_propCount; i++ ) _target[ _properties[i] ] = _easing( _timeElapsed, _fromVars[i], _toVars[i]-_fromVars[i], _duration );
				_options.onUpdate.apply( null, _options.onUpdateParams );
		}
			
	}
		
}