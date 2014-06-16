/**
 * Twee
 * @author Sreenath Somarajapuram
 */

package tiger.twee.easing;

import com.tiger.twee.interfaces.IEase;

class Sine
{
	public static const easeIn:IEase = new EaseIn;
	public static const easeOut:IEase = new EaseOut;
	public static const easeInOut:IEase = new EaseInOut;
}

private class EaseIn implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return -c * Math.cos(t / d * (Math.PI / 2)) + c + s;
	}
}

private class EaseOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return c * Math.sin(t / d * (Math.PI / 2)) + s;
	}	
}

private class EaseInOut implements IEase{
	public function compute( t:Float, s:Float, c:Float, d:Float ):Float{
		return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + s;
	}
}
