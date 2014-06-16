/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee;

public class Twee{	

	public static function to( target:Dynamic, duration:Float, vars:Dynamic, options:Dynamic=null ):Tween{
		options||={};
		if( options.onUpdate ) return new TweenWithUpdate( target, duration, null, vars, options );
		return new Tween( target, duration, null, vars, options );
	}

	public static function from( target:Dynamic, duration:Float, vars:Dynamic, options:Dynamic=null ):Tween{
		options||={};
		if( options.onUpdate ) return new TweenWithUpdate( target, duration, vars, null, options );
		return new Tween( target, duration, vars, null, options );
	}

	public static function fromTo( target:Dynamic, duration:Float, fromVars:Dynamic, toVars:Dynamic, options:Object=null ):Tween{
		options||={};
		if( options.onUpdate ) return new TweenWithUpdate( target, duration, fromVars, toVars, options );
		return new Tween( target, duration, fromVars, toVars, options );
	}

	public static function killTweensOf( target:Dynamic, complete:Bool=false ):void{
		Tween.killTweensOf( target, complete );
	}
	
}