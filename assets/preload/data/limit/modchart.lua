function start (song)
	hudX = getHudX()
    hudY = getHudY()

	WhiteBG = makeSprite('White','whitebg', true)
	BlackBG = makeSprite('Black','blackbg', true)
	WhiteFade = makeSprite('White','whitefade', false)
	BlackFade = makeSprite('Black','blackfade', false)

	setActorX(200,'whitebg')
	setActorY(500,'whitebg')
	setActorAlpha(0,'whitebg')
	setActorScale(4,'whitebg')
	
	setActorX(200,'blackbg')
	setActorY(500,'blackbg')
	setActorAlpha(0,'blackbg')
	setActorScale(4,'blackbg')
	
	setActorX(200,'blackfade')
	setActorY(500,'blackfade')
	setActorAlpha(0,'blackfade')
	setActorScale(4,'blackfade')
	
	setActorX(200,'whitefade')
	setActorY(500,'whitefade')
	setActorAlpha(1,'whitefade')
	setActorScale(4,'whitefade')
	
	hide = true
	setHudPosition(0, 1000)
	camHudAngle = -10
	shakenotep1 = false
	shakenotep2 = false
end

function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)
	hudX = getHudX()
    hudY = getHudY()
	
	if zoom then
		setCamZoom(2)
	end
	
	if hide then
		for i=0,7 do
			setActorAlpha(0,i)
		end
	end
	
    if sway then
        camHudAngle = 6 * math.sin((currentBeat))
    end
	
	if shakehud then
		for i=0,7 do
			setHudPosition(20 * math.sin((currentBeat * 10 + i*0.25) * math.pi), 20 * math.cos((currentBeat * 10 + i*0.25) * math.pi))
			setCamPosition(-20 * math.sin((currentBeat * 10 + i*0.25) * math.pi), -20 * math.cos((currentBeat * 10 + i*0.25) * math.pi))
		end
	end
	
	if shakehorizontal then
		for i=0,7 do
			setHudPosition(10 * math.sin((currentBeat * 10 + i*0.25) * math.pi), 0)
			setCamPosition(5 * math.sin((currentBeat * 10 + i*0.25) * math.pi),0)
		end
	end

	if sustainshake then
		for i=0,7 do
			setHudPosition(10 * math.sin((currentBeat * 15 + i*0.25) * math.pi), 10 * math.cos((currentBeat * 15 + i*0.25) * math.pi))
			setCamPosition(5 * math.sin((currentBeat * 10 + i*0.25) * math.pi), 5 * math.cos((currentBeat * 10 + i*0.25) * math.pi))
		end
	end
	
	if shakenotep1 then
		for i=0,3 do
			setActorX(_G['defaultStrum'..i..'X'] + 3 * math.sin((currentBeat * 10 + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 3 * math.cos((currentBeat * 10 + i*0.25) * math.pi) + 10, i)
		end
	end
	if shakenotep2 then
		for i=4,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 3 * math.sin((currentBeat * 10 + i*0.25) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 3 * math.cos((currentBeat * 10 + i*0.25) * math.pi) + 10, i)
		end
	end
end

function beatHit (beat)
end

function stepHit (step)
	if step == 16 then
		tweenFadeOut(WhiteFade,0,8)
		setHudPosition(0, 0)
		camHudAngle = 0
		hide = false
		for i=0,7 do
			tweenFadeOut(i,1,8)
		end
	end
	if step == 252 then
		shakehud = true	
	end
	if step == 256 then
		shakehud = false
		setHudPosition(0,0)
		setCamPosition(0,0)
	end
	if step == 380 then
		shakehud = true
	end
	if step == 384 then
		shakehud = false
		setHudPosition(0,0)
		setCamPosition(0,0)
		shakenotep1 = true
	end
	if step == 448 then
		shakenotep1 = false
		for i=0,3 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10, i)
		end
		shakenotep2 = true
	end
	if step == 512 then
		shakenotep2 = false
		for i=4,7 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10, i)
		end
	end
	
	--start of angles
	
	-- first angle hold
	if step == 512 then
		camHudAngle = -5
	end
	if step == 518 then
		camHudAngle = -10
	end
	if step == 524 then
		camHudAngle = 10
	end
	if step == 530 then
		camHudAngle = -10
	end
	if step == 536 then
		camHudAngle = -5
	end
	if step == 540 then
		camHudAngle = 10
	end
	if step == 541 then
		camHudAngle = 0
	end
	if step == 542 then
		camHudAngle = 10
	end
	if step == 544 then
		camHudAngle = -10
	end
	if step == 550 then
		camHudAngle = 10
	end
	if step == 556 then
		camHudAngle = 5
	end
	if step == 562 then
		camHudAngle = -10
	end
	
	--second angle hold
	if step == 576 then
		camHudAngle = -5
	end
	if step == 582 then
		camHudAngle = -10
	end
	if step == 588 then
		camHudAngle = 10
	end
	if step == 594 then
		camHudAngle = -10
	end
	if step == 600 then
		camHudAngle = -5
	end
	if step == 604 then
		camHudAngle = 10
	end
	if step == 605 then
		camHudAngle = 0
	end
	if step == 606 then
		camHudAngle = 10
	end
	if step == 608 then
		camHudAngle = -15
	end
	if step == 614 then
		camHudAngle = 0
	end
	if step == 556 then
		camHudAngle = 15
	end
	if step == 626 then
		camHudAngle = 0
	end
	
	--third angle hold
	if step == 640 then
		shakenotep1 = true
		shakenotep2 = true
		sustainshake = true
		camHudAngle = -5
	end
	if step == 646 then
		camHudAngle = -10
	end
	if step == 652 then
		camHudAngle = 10
	end
	if step == 658 then
		camHudAngle = -10
	end
	if step == 664 then
		camHudAngle = -5
	end
	if step == 668 then
		camHudAngle = 10
	end
	if step == 669 then
		camHudAngle = 0
	end
	if step == 670 then
		camHudAngle = 10
	end
	if step == 672 then
		camHudAngle = -15
	end
	if step == 678 then
		camHudAngle = 0
	end
	if step == 684 then
		camHudAngle = 15
	end
	if step == 690 then
		camHudAngle = 0
	end
	
	--final angle hold

	if step == 704 then
		camHudAngle = -5
	end
	if step == 710 then
		camHudAngle = -10
	end
	if step == 716 then
		camHudAngle = 10
	end
	if step == 722 then
		camHudAngle = -10
	end
	if step == 728 then
		camHudAngle = -5
	end
	if step == 732 then
		camHudAngle = 10
	end
	if step == 733 then
		camHudAngle = 0
	end
	if step == 734 then
		camHudAngle = 10
	end
	if step == 736 then
		camHudAngle = -10
	end
	if step == 742 then
		camHudAngle = 10
	end
	if step == 748 then
		camHudAngle = 15
	end
	if step == 754 then
		sustainshake = false
		setCamPosition(0,0)
		setHudPosition(0,0)
		camHudAngle = 0
		tweenFadeIn(WhiteFade, 1, 0.01)
		tweenFadeIn(BlackBG, 1, 0.01)
	end
	if step == 755 then
		tweenFadeOut(WhiteFade, 0, 0.4)
	end

-- end of angles

	if step == 768 then
		shakenotep2 = false
		for i=4,7 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10, i)
		end
		tweenFadeOut(BlackBG, 0, 0.3)
		zoom = false
	end
	if step == 832 then
		shakenotep1 = false
		shakenotep2 = true
		for i=0,3 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10, i)
		end
	end
	if step == 896 then
		shakenotep1 = false
		shakenotep2 = false
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10, i)
		end
		shakehorizontal = true
	end
	if step == 960 then
		tweenFadeIn(WhiteFade, 1, 0.01)
		tweenFadeIn(BlackBG, 1, 0.01)
		shakenotep1 = true
		shakenotep2 = true
		sway = true
		shakehorizontal = false
		sustainshake = true
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'], i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10, i)
		end
	end
	if step == 961 then
		tweenFadeOut(WhiteFade, 0, 0.2)
	end
	if step == 1152 then
		tweenFadeIn(WhiteFade, 1, 0.01)
		tweenFadeOut(BlackBG, 0, 0.01)
	end
	if step == 1153 then
		tweenFadeOut(WhiteFade, 0, 1)
		shakenotep1 = false
		shakenotep2 = false
		sustainshake = false
		sway = false
		camHudAngle = 0
		setCamPosition(0,0)
		setHudPosition(0,0)
	end
end