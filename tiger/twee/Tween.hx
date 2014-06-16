/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee;

import haxe.io.Error;
import tiger.twee.easing.Quadratic;
import tiger.twee.interfaces.IEase;
import tiger.twee.interfaces.ITwee;
import tiger.utils.statics.ExUtils;

#if (flash || nme || openfl)
import flash.events.Event;
import flash.Lib;
#else
import haxe.Timer;
#end
	
class Tween implements ITwee{

	private static var _tweens:Array<Tween> = new Array<Tween>(0);
	private static var _tweensToDel:Array<Tween> = new Array<Tween>(0);
	private static var _prevTime:Int; // In millisec
	
	#if (!flash && !nme && !openfl)
	private static var _trigger:Timer;
	#end
		
	private var _target:Dynamic;
	private var _duration:Int;
	private var _tailedTwees:Array;
	private var _index:Int;
	private var _started:Bool = false;

	private var _toVars:Array<Float>;
	private var _fromVars:Array<Float>;
	private var _properties:Array<String>;
	private var _propCount:Int = 0;
	
	private var _toVarObj:Dynamic;
	private var _fromVarObj:Dynamic;

	private var _easing:IEase;
	private var _options:Dynamic;
	private var _repeat:Int;

	private var _timeElapsed:Int=0;
				
	public function new( target:Dynamic, duration:Float, fromVars:Dynamic, toVars:Dynamic, options:Dynamic ){
			
		_target = target,
		_duration = duration*1000,
		_fromVarObj = fromVars,
		_toVarObj = toVars,
		
		//-------------Set Options
		_options = options || {},
		_easing = _options.easing || Quadratic.easeOut,
		_repeat = _options.repeat || 1;
		//-------------
			
		// Auto deactivation for tailed tweens
		if( !_options.inactive ) activate();

	}
	
	public function start():Bool{
		if( _started ) return false; // Already active
		if( _options.delay!=undefined ) ExUtils.delayedCall( add, _options.delay );
		else add();
		return true;
	}
	
	private function add():Void{

		if ( !_target ) throw( new Error("The instance was destroyed.") );
		
		var propertyName:String;
		
		_properties = new Array<String>();
		_toVars = new Array<Float>();
		_fromVars = new Array<Float>();
			
		if( _fromVarObj && !_toVarObj ){
			for( propertyName in _fromVarObj ){
				if( _target.hasOwnProperty(propertyName) ){
					_properties[ _propCount ] = propertyName;
					_fromVars[ _propCount ] = _fromVarObj[propertyName];
					_toVars[ _propCount++ ] = _target[propertyName];
				}
			else throw( new Error("Property "+propertyName+" not found in target!") );
			}
		}
		else if( !_fromVarObj && _toVarObj ){
			for( propertyName in _toVarObj ){
				if( _target.hasOwnProperty(propertyName) ){
					_properties[ _propCount ] = propertyName;
					_fromVars[ _propCount ] = _target[propertyName];
					_toVars[ _propCount++ ] = _toVarObj[propertyName];
				}
				else throw( new Error("Property "+propertyName+" not found in target!") );
			}
		}
		else{
			for( propertyName in _fromVarObj ){
				if( _target.hasOwnProperty(propertyName) ){
					_properties[ _propCount ] = propertyName;
					_fromVars[ _propCount ] = _fromVarObj[propertyName];
					_toVars[ _propCount++ ] = _toVarObj[propertyName];
				}
				else throw( new Error("Property "+propertyName+" not found in target!") );
			}
		}
			
		_index = _tweens.length;
		_tweens[ _index ] = this;
			
		if( _index==0 ){
			_prevTime = Lib.getTimer();
			
			#if (flash || nme || openfl)
			Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			#else
			_trigger = _trigger || new Timer(Std.int(1000 / 30));
			_trigger.run = onEnterFrame;
			#end
			
		}
		
		_started = true;
	}
		
	public function render( timeDelta:Int ):Void{
		
		var i:Int, count:Int, fromVal:Int;
		var tmp:Array<Float>;
			
		if( _timeElapsed==_duration ){ // So that the callback is called in next frame.
			if( _repeat==1 ){
				if( Reflect.isFunction(_options.onComplete) ) _options.onComplete.apply( null, _options.onCompleteParams );
				if(_tailedTwees) for( i in 0.._tailedTwees.length ) _tailedTwees[i].activate();
				destroy();
			}
			else{
				_repeat--;
				_timeElapsed = 0;
				if( _options.yoyo ) tmp = _toVars, _toVars = _fromVars, _fromVars = tmp;
//				if( _options.yoyo ) tmp = _toVars, _toVars = _fromVars, _fromVars = tmp;
			}
		}
		else{
			_timeElapsed += timeDelta;
			if( _timeElapsed>_duration ) _timeElapsed=_duration;
			
			for( i=0 in 0.._propCount ) _target[ _properties[i] ] = _easing.compute( _timeElapsed, fromVal = _fromVars[i], _toVars[i]-fromVal, _duration );
		}
			
	}
		
	public function tail( tween:ITwee ):Bool{
		if( !_target ) return false;
		_tailedTwees |= [];
		_tailedTwees.concat(args);
		return true;
	}
		
	public function destroy():Void{
		if( _options ){
			_tweensToDel[ _tweensToDel.length ] = this;
			
			//-------------Reset vars
			_options = null,
			_easing = null;
			
			_target = null,
			_duration = 0,
			_tailedTwees = null,
//			_index:Int;
//			_active:Bool;
				
			_toVars = null,
			_fromVars = null,
			_properties = null,
//			_propCount;
				
			_toVarObj = null,
			_fromVarObj = null,
				
			_easing = null,
			_options = null,
//			_repeat:Int;
			
			_timeElapsed = 0;
			//-------------
		}
	}
		
	public static function killTweensOf( target:Dynamic, complete:Bool ):Void{
		var tween:Tween;
		for( var i:Int in 0.._tweens.length ){
			tween = _tweens[i];
			if( tween._target == target ){
				if( complete && Reflect.isFunction(tween._options.onComplete) ) tween._options.onComplete.apply( null, tween._options.onCompleteParams );
				tween.destroy();
			}
		}
	}

	private static function onEnterFrame( #if (flash || nme || openfl) e:Event #end ):Void{
		var time:Int = Lib.getTimer();
		var timeDelta:Int = time-_prevTime;
		var i:Int=0, count:Int, len:Int, delIndex:Int;

		len = _tweens.length-1;
		if( _tweensToDel.length!=0 ){
			for( i in 0.._tweensToDel.length ){
				delIndex = _tweensToDel[i]._index;
				(_tweens[delIndex] = _tweens[len])._index = delIndex;
				len--;
			}
			_tweens.length = len+1;
			_tweensToDel.length=0;
		}

		
		if ( len < 0 ) {
			#if (flash || nme || openfl)
			Lib.current.stage.removeEventListener (Event.ENTER_FRAME, onEnterFrame);
			#else
			_trigger.stop();
			_trigger.run = null;
			#end
		}
		else for( i=0 in 0.._tweens.length ) _tweens[i].render( timeDelta );
		
		_prevTime = time;
	}
		
}