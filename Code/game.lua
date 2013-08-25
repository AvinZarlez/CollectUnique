-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local num_patterns
local num_colors
local num_collectibles
local num_time


local pattern_size = 256
local pattern_qrt = 256/4
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local CollectButton, DiscardButton

local correct_background,incorrect_background

local buttonGroup, currentGroup, pastGroup

local num_collected
local currentCollectible
local currentCollectibleNums

local push_dist

local uniques

local score_correct
local score_incorrect
local score_combo
local score_total

local start_time, time_text, t


local function endGame(  )
	start_time = -1
	local options =
	{
	    effect = "fromTop",
	    time = 500,
	    params =
	    {
	    	correct = score_correct,
	        incorrect = score_incorrect,
	        final = score_total,
	    }
	}
	storyboard.gotoScene( "endgame", options )
end


local function createPattern(  )
	local pattern = display.newGroup()

	local current_background = display.newRoundedRect( 0, 0, pattern_size, pattern_size, 16 )
	current_background:setFillColor( 128 )
	pattern:insert(current_background)

	local rand = math.random (1,num_patterns);
	local obj
	
	if (rand == 1) then -- Complex shapes to add later
		obj = display.newCircle( pattern_size/2, pattern_size/2, pattern_size/3 )
	elseif (rand == 2) then
		obj = display.newRect( 32,32, pattern_size-64, pattern_size-64 )
	elseif (rand == 3) then 
		obj = display.newRoundedRect( 64+16, 32, pattern_size-128-16,pattern_size-64,32 )
	else--if (rand == 4) then
		obj = display.newRoundedRect( 32,64+16, pattern_size-64, pattern_size-128-16,32 )
	end

	local rand_C = math.random (1,num_colors);
	if (rand_C == 1) then
		obj:setFillColor( 255, 32, 32, 255 )
	elseif (rand_C == 2) then
		obj:setFillColor( 32, 255, 32, 255 )
	elseif (rand_C == 3) then
		obj:setFillColor( 32, 32, 255, 255 )
	else--if (rand == 4) then
		obj:setFillColor( 255, 255, 255, 255 )
	end

	currentCollectibleNums = {rand,rand_C}

	pattern:insert(obj)

	return pattern
end

local function newCollectible(  )
	correct_background.isVisible = false
	incorrect_background.isVisible = false
	if (num_collected < num_collectibles) then
		currentCollectible = createPattern()
		currentGroup:insert(currentCollectible)
		start_time = os.time()
	else
		endGame()
	end
end

local function nextCollectible( collected )
	
	local is_unique = true
	for k,v in pairs(uniques) do
		if ((v[1] == currentCollectibleNums[1])and(v[2] == currentCollectibleNums[2])) then is_unique = false end
	end

	local current_background = display.newRoundedRect( 0, 0, pattern_size, pattern_size, 16 )
	current_background.strokeWidth = 16
	current_background:setFillColor(128, 128, 128,0)
	currentCollectible:insert(current_background)

	if (is_unique) then
		table.insert(uniques, currentCollectibleNums)
	else
		if (collected ~= -1) then --check for auto fail
			collected = not collected
		end
	end

	if (collected == -1) or (collected == false) then -- -1 is an autofail
		score_combo = 0
		score_incorrect = score_incorrect + 1
		current_background:setStrokeColor(180, 64, 64)
		incorrect_background.isVisible = true
	else
		score_total = score_total + 100 + (50*score_combo)
		score_combo = score_combo+1
		score_correct = score_correct + 1
		current_background:setStrokeColor(64, 180, 64)
		correct_background.isVisible = true
	end

	currentCollectible.xScale = 0.25
	currentCollectible.yScale = 0.25

	pastGroup:insert(currentCollectible)

	currentCollectible.x = 4 + (num_collected*(pattern_qrt+8))
	num_collected = num_collected+1

	if (num_collected > 4) then
		transition.to(pastGroup, {time = 250, x = (screenW - (num_collected*(pattern_qrt+8)))})
		push_dist = (screenW - (num_collected*(pattern_qrt+8)));
	end

	start_time = -1
	time_text.text = "-"
	t = timer.performWithDelay(500,newCollectible)
end

local function discardButtonEvent( event )
    local phase = event.phase 

    if "ended" == phase and start_time ~= -1 then
		nextCollectible(false)
	end
end
local function collectButtonEvent( event )
    local phase = event.phase 

    if "ended" == phase and start_time ~= -1 then

		nextCollectible(true)
	end
end

local function newGame(  )
	score_correct = 0
	score_incorrect = 0
	score_combo = 0
	score_total = 0

	num_collected = 0
	push_dist = 0
	pastGroup.x = 0

	uniques = {}

	newCollectible()
end

local function countdownTimer( event )
	if (start_time > 0) then
		local seconds =  os.time()-start_time
		if (seconds < num_time) then
			time_text.text = num_time-seconds
		else
			nextCollectible(-1)
		end
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newRect( 0, 0, screenW, screenH )
	background:setFillColor( 32+16 )

	-- all display objects must be inserted into group
	group:insert( background )

	local background_past = display.newRect( 0, 32 + pattern_size + 32 - 4, screenW, pattern_qrt + 8)
	background_past:setFillColor( 128,128,128,64 )
	group:insert( background_past )

	pastGroup = display.newGroup()
	pastGroup.y = 32 + pattern_size + 32
	group:insert( pastGroup )

	currentGroup = display.newGroup()
	currentGroup.x = (screenW-pattern_size)/2; currentGroup.y = 32
	group:insert( currentGroup )


	correct_background = display.newRoundedRect( 0, 0, pattern_size, pattern_size, 16 )
	correct_background:setFillColor( 128,255,128 )
	correct_background.isVisible = false
	currentGroup:insert(correct_background)
	incorrect_background = display.newRoundedRect( 0, 0, pattern_size, pattern_size, 16 )
	incorrect_background:setFillColor( 255,128,128 )
	incorrect_background.isVisible = false
	currentGroup:insert(incorrect_background)



	buttonGroup = display.newGroup()
	group:insert( buttonGroup )

	DiscardButton = widget.newButton
	{
	    left = halfW-10-128,
	    top = screenH-64-8,
	    width = 128,
	    height = 50,
	    id = "collect",
	    label = "Repeat",
	    onEvent = discardButtonEvent,
	}
	-- Insert the button into a group:
	buttonGroup:insert( DiscardButton )


	CollectButton = widget.newButton
	{
	    left = halfW+10,
	    top = screenH-64-8,
	    width = 128,
	    height = 50,
	    id = "collect",
	    label = "Unique",
	    onEvent = collectButtonEvent,
	}

	-- Insert the button into a group:
	buttonGroup:insert( CollectButton )


	local touch_eater_slider = display.newRect( 0, 32 + pattern_size + 32, screenW, pattern_qrt )
	touch_eater_slider:setFillColor( 128,128,128,0 )
	function touch_eater_slider:touch( event )
	    if event.phase == "began" then
	        --print( "Touch event began on: " .. self.id )

	        -- set touch focus
	        display.getCurrentStage():setFocus( self )
	        self.isFocus = true

	    elseif self.isFocus then
	        if event.phase == "moved" then
	            pastGroup.x = push_dist + event.x-event.xStart

	            if (pastGroup.x > 0) then pastGroup.x = 0 end
	            if (pastGroup.x < (screenW - (num_collected*(pattern_qrt+8)))) then
	            	if (num_collected > 4) then
	            		pastGroup.x = (screenW - (num_collected*(pattern_qrt+8)))
	            	else
	            		pastGroup.x = 0
	            	end
	            end


	        elseif event.phase == "ended" or event.phase == "cancelled" then

	            print( "ended " ..  event.xStart-event.x)
	        	push_dist = pastGroup.x


	            -- reset touch focus
	            display.getCurrentStage():setFocus( nil )
	            self.isFocus = nil
	        end
	    end
	    return true
	end 
	touch_eater_slider:addEventListener( "touch", touch_eater_slider )
	buttonGroup:insert( touch_eater_slider )

	time_text = display.newText("-", screenW-26, 0,  native.systemFont, 32)
	time_text:setTextColor(255, 255, 255)
	group:insert(time_text)

	start_time = -1
	Runtime:addEventListener( "enterFrame", countdownTimer );
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
    local params = event.params

    num_patterns  = params.patterns
    num_colors  = params.colors
    num_collectibles  = params.collectibles
    num_time = params.time

	newGame()
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	for i=1,pastGroup.numChildren do
    	local child = pastGroup[1]
		display.remove(child)
	end

	start_time = -1

	timer.cancel(t)
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	if DiscardButton then
		DiscardButton:removeSelf()	-- widgets must be manually removed
		DiscardButton = nil
	end
	if CollectButton then
		CollectButton:removeSelf()	-- widgets must be manually removed
		CollectButton = nil
	end

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