-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

local num_patterns
local num_colors
local num_collectibles
local num_time

local slider_patterns,slider_colors,slider_collectibles,slider_time

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to game.lua scene
	local options =
	{
	    effect = "fromTop",
	    time = 500,
	    params =
	    {
	    	patterns = num_patterns,
	    	colors = num_colors,
	    	collectibles = num_collectibles,
	    	time = num_time,
	    }
	}
	storyboard.gotoScene( "game", options )
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	background:setFillColor( 32 )

	local logo = display.newText("Collect Unique", 0, 32,  native.systemFont, 42)
	logo.x = display.contentWidth/2
	logo:setTextColor(255, 255, 255)


	local desc1 = display.newText("Within the time limit press 'Unique'", 0,  display.contentHeight-128-32,  native.systemFont, 14)
	desc1.x = display.contentWidth/2
	desc1:setTextColor(255, 255, 255)
	local desc2 = display.newText("if you have not seen the pattern before,", 0,  display.contentHeight-128+20-32,  native.systemFont, 14)
	desc2.x = display.contentWidth/2
	desc2:setTextColor(255, 255, 255)
	local desc3 = display.newText("otherwise press 'Repeat'!", 0,  display.contentHeight-128+40-32,  native.systemFont, 14)
	desc3.x = display.contentWidth/2
	desc3:setTextColor(255, 255, 255)
	
	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play Now",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 64

	local function onPatternPress( event )
	    local target = event.target

	    --print( "Segment Label is:", target.segmentLabel )
	    --print( "Segment Number is:", target.segmentNumber )
	    num_patterns = target.segmentNumber+1
	end
	local label_patterns = display.newText("Shapes:", 10, 128-20,  native.systemFont, 20)
	label_patterns:setTextColor(255, 255, 255)
	-- Create a default segmented control (using widget.setTheme)
	local slider_patterns = widget.newSegmentedControl
	{
	    left = 104,
	    top = 128-2-20,
	    segments = { "Two","Three","Four" },
	    defaultSegment = 2,
	    onPress = onPatternPress,
	}
	num_patterns = 3

	local function onColorPress( event )
	    local target = event.target

	    --print( "Segment Label is:", target.segmentLabel )
	    --print( "Segment Number is:", target.segmentNumber )
	    num_colors = target.segmentNumber
	end
	local label_colors = display.newText("Colors:", 10, 128+64-30,  native.systemFont, 20)
	label_colors:setTextColor(255, 255, 255)
	-- Create a default segmented control (using widget.setTheme)
	local slider_colors = widget.newSegmentedControl
	{
	    left = 104,
	    top = 128-2 + 64-30,
	    segments = { "One","Two","Three","Four" },
	    defaultSegment = 3,
	    onPress = onColorPress,
	}
	num_colors = 3

	local function onCollectiblesPress( event )
	    local target = event.target

	    --print( "Segment Label is:", target.segmentLabel )
	    --print( "Segment Number is:", target.segmentNumber )
	    num_collectibles = target.segmentNumber*5
	end
	local label_collectibles = display.newText("Quantity:", 10, 128+128-40,  native.systemFont, 20)
	label_collectibles:setTextColor(255, 255, 255)
	-- Create a default segmented control (using widget.setTheme)
	local slider_collectibles = widget.newSegmentedControl
	{
	    left = 104,
	    top = 128-2 + 128-40,
	    segments = { "5","10","15","20" },
	    defaultSegment = 2,
	    onPress = onCollectiblesPress,
	}
	num_collectibles = 10


	local function onTimePress( event )
	    local target = event.target

	    --print( "Segment Label is:", target.segmentLabel )
	    --print( "Segment Number is:", target.segmentNumber )
	    num_time = target.segmentNumber
	    if (num_time == 1) then num_time = 2
	    elseif (num_time == 2) then num_time = 3
	    elseif (num_time == 3) then num_time = 5
	    else num_time = 7 end
	end
	local label_time = display.newText("Time:", 10, 128+192-50,  native.systemFont, 20)
	label_collectibles:setTextColor(255, 255, 255)
	-- Create a default segmented control (using widget.setTheme)
	local slider_time = widget.newSegmentedControl
	{
	    left = 104,
	    top = 128-2 + 192-50,
	    segments = { "2","3","5","7" },
	    defaultSegment = 2,
	    onPress = onTimePress,
	}
	num_time = 3
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( logo )
	group:insert( desc1 )
	group:insert( desc2 )
	group:insert( desc3 )
	group:insert( playBtn )

	group:insert(label_patterns)
	group:insert(slider_patterns)

	group:insert(label_colors)
	group:insert(slider_colors)

	group:insert(label_collectibles)
	group:insert(slider_collectibles)

	group:insert(label_time)
	group:insert(slider_time)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end

	slider_patterns:remove()
	slider_colors:remove()
	slider_collectibles:remove()
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene