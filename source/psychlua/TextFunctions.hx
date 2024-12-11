package psychlua;

class TextFunctions
{
	public static function implement(funk:FunkinLua)
	{
		var lua = funk.lua;
		var game:PlayState = PlayState.instance;
		var luaTrace = FunkinLua.luaTrace; //I'm lazy
		
		Lua_helper.add_callback(lua, "makeLuaText", function(tag:String, text:String, width:Int, x:Float, y:Float) {
			tag = tag.replace('.', '');
			LuaUtils.resetTextTag(tag);
			var leText:ModchartText = new ModchartText(x, y, text, width);
			game.modchartTexts.set(tag, leText);
		});

		Lua_helper.add_callback(lua, "setTextString", function(tag:String, text:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				obj.text = text;
				return true;
			}
			luaTrace("setTextString: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextSize", function(tag:String, size:Int) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				obj.size = size;
				return true;
			}
			luaTrace("setTextSize: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextWidth", function(tag:String, width:Float) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				obj.fieldWidth = width;
				return true;
			}
			luaTrace("setTextWidth: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextBorder", function(tag:String, size:Int, color:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				var colorNum:Null<FlxColor> = FlxColor.fromString(color);
				if(colorNum == null) colorNum = FlxColor.fromString('0x' + color);
				if(colorNum == null) colorNum = FlxColor.WHITE; //fail safe
				if(size > 0)
				{
					obj.borderStyle = OUTLINE;
					obj.borderSize = size;
				}
				else
					obj.borderStyle = NONE;
				obj.borderColor = colorNum;
				return true;
			}
			luaTrace("setTextBorder: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextColor", function(tag:String, color:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				var colorNum:Null<FlxColor> = FlxColor.fromString(color);
				if(colorNum == null) colorNum = FlxColor.fromString('0x' + color);
				if(colorNum == null) colorNum = FlxColor.WHITE; //fail safe
				obj.color = colorNum;
				return true;
			}
			luaTrace("setTextColor: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextFont", function(tag:String, newFont:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				obj.font = Paths.font(newFont);
				return true;
			}
			luaTrace("setTextFont: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextItalic", function(tag:String, italic:Bool) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				obj.italic = italic;
				return true;
			}
			luaTrace("setTextItalic: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		Lua_helper.add_callback(lua, "setTextAlignment", function(tag:String, alignment:String = 'left') {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				obj.alignment = LEFT;
				switch(alignment.trim().toLowerCase())
				{
					case 'right':
						obj.alignment = RIGHT;
					case 'center':
						obj.alignment = CENTER;
				}
				return true;
			}
			luaTrace("setTextAlignment: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});

		Lua_helper.add_callback(lua, "getTextString", function(tag:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null && obj.text != null)
			{
				return obj.text;
			}
			luaTrace("getTextString: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return null;
		});
		Lua_helper.add_callback(lua, "getTextSize", function(tag:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				return obj.size;
			}
			luaTrace("getTextSize: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return -1;
		});
		Lua_helper.add_callback(lua, "getTextFont", function(tag:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				return obj.font;
			}
			luaTrace("getTextFont: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return null;
		});
		Lua_helper.add_callback(lua, "getTextWidth", function(tag:String) {
			var obj:FlxText = LuaUtils.getTextObject(tag);
			if(obj != null)
			{
				return obj.fieldWidth;
			}
			luaTrace("getTextWidth: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return 0;
		});
		
		Lua_helper.add_callback(lua, "addLuaText", function(tag:String) {
			if(game.modchartTexts.exists(tag)) {
			    var shit:ModchartText = game.modchartTexts.get(tag);
				if(!shit.wasAdded) {
					LuaUtils.getTargetInstance().add(shit);
					shit.wasAdded = true;
					//trace('added a thing: ' + tag);
				}
			}
		});
		Lua_helper.add_callback(lua, "removeLuaText", function(tag:String, destroy:Bool = true) {
			if(!game.modchartTexts.exists(tag)) {
				return;
			}
			var pee:ModchartText = game.modchartTexts.get(tag);
			if(destroy) {
				pee.kill();
			}
			if(pee.wasAdded) {
				LuaUtils.getTargetInstance().remove(pee, true);
				pee.wasAdded = false;
			}
			if(destroy) {
				pee.destroy();
				game.modchartTexts.remove(tag);
			}
		});
	}
}