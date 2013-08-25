-----------------------------------------------------------------------------------------
--
-- pausemenu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require "widget"

-- forward declarations and other locals
local playBtn

local scoreCorrectText, scoreIncorrectText

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()

	-- go to menu.lua scene
	storyboard.gotoScene( "menu", "fromBottom", 500 )
	
	return true	-- indicates successful touch
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	local greyout = display.newRect(display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight)
	greyout:setFillColor(64,64,64)
	group:insert(greyout)

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Back",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 64
	
	-- all display objects must be inserted into group
	group:insert( playBtn )

	scoreCorrectTextLabel = display.newText("Correct Answers:", 0, 32,  native.systemFont, 28)
	scoreCorrectTextLabel.x = display.contentWidth/2
	scoreCorrectTextLabel:setTextColor(255, 255, 255)
	group:insert( scoreCorrectTextLabel )

	scoreIncorrectTextLabel = display.newText("Incorrect Answers:", 0, 128,  native.systemFont, 28)
	scoreIncorrectTextLabel.x = display.contentWidth/2
	scoreIncorrectTextLabel:setTextColor(255, 255, 255)
	group:insert( scoreIncorrectTextLabel )


	scoreCorrectText = display.newText("", 0, 32+42,  native.systemFont, 38)
	scoreCorrectText.x = display.contentWidth/2
	scoreCorrectText:setTextColor(128, 255, 128)
	group:insert( scoreCorrectText )

	scoreIncorrectText = display.newText("", 0, 128+42,  native.systemFont, 38)
	scoreIncorrectText.x = display.contentWidth/2
	scoreIncorrectText:setTextColor(255, 128, 128)
	group:insert( scoreIncorrectText )




	scoreFinalTextLabel = display.newText("Final Score:", 0, 256-12,  native.systemFont, 36)
	scoreFinalTextLabel.x = display.contentWidth/2
	scoreFinalTextLabel:setTextColor(255, 255, 255)
	group:insert( scoreFinalTextLabel )

	scoreFinalText = display.newText("", 0, 256+42,  native.systemFont, 42)
	scoreFinalText.x = display.contentWidth/2
	scoreFinalText:setTextColor(128, 128, 255)
	group:insert( scoreFinalText )

end

function scene:willEnterScene( event )
	
    local params = event.params

    scoreCorrectText.text   = params.correct..""
    scoreIncorrectText.text = params.incorrect..""
    scoreFinalText.text     = params.final..""

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )
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