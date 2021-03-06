package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;
	var voiceLine:FlxSound;
	var curDialogue:Int = 0;

	var linesPrefix:String = '';

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'escape reality' | 'limit' | 'shock':
				/*FlxG.sound.playMusic(Paths.music('bad', 'noke'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);*/
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		voiceLine = new FlxSound();
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'escape reality' | 'limit' | 'shock':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.y += 320;
				box.animation.addByPrefix('normalOpen', 'speech bubble normal', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [11], "", 24);

				/*var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/senpaiPortait', 'week6'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);*/
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'escape reality' | 'limit' | 'shock':
				portraitRight = new FlxSprite(0, 0);
				portraitLeft = new FlxSprite(-60, 40).loadGraphic(Paths.image('Fueg0Happy', 'fueg0'));
				portraitRight = new FlxSprite(-60, 40).loadGraphic(Paths.image('portraits/gf', 'fueg0'));
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
			default:
				portraitRight = new FlxSprite(0, 40);
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		}
		
		switch(PlayState.SONG.song.toLowerCase()) {
			case 'shock':
				linesPrefix = 'shock';
			case 'limit':
				linesPrefix = 'Limit';
			case 'escape reality':
				linesPrefix = 'escapereality';
		}
		
		add(portraitLeft);
		portraitLeft.visible = false;
		
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'escape reality' | 'limit' | 'shock':
				//offset stuff
		}

		
		add(handSelect);


		if (!talkingRight)
		{
			box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		switch (PlayState.SONG.song.toLowerCase()) {
			case 'roses':
				portraitLeft.visible = false;
			case 'thorns':
				portraitLeft.color = FlxColor.BLACK;
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
		}
		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		if (FlxG.mouse.justPressed) {
			voiceLine.play();
		}
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		curDialogue++;
		if (voiceLine.playing)
			voiceLine.stop();
		voiceLine = voiceLine.loadEmbedded(Paths.sound(linesPrefix + '/' + linesPrefix + Std.string(curDialogue), 'fueg0'));
		trace(linesPrefix + Std.string(curDialogue));
		voiceLine.play();
		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('enter');
				}
			case 'fueg0happy':
				portraitRight.visible = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(-300, -250).loadGraphic(Paths.image('portraits/Fueg0Happy', 'fueg0'));
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.3));
				add(portraitLeft);
				portraitLeft.visible = true;
				box.flipX = true;
			case 'fueg0mad':
				portraitRight.visible = false;
				remove(portraitLeft);
				portraitLeft = new FlxSprite(-180, -100).loadGraphic(Paths.image('portraits/Fueg0Mad', 'fueg0'));
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				add(portraitLeft);
				portraitLeft.visible = true;
				box.flipX = true;
			case 'gf':
				portraitLeft.visible = false;
				remove(portraitRight);
				portraitRight = new FlxSprite(800, 80).loadGraphic(Paths.image('portraits/gf', 'fueg0'));
				//portraitRight.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				add(portraitRight);
				portraitRight.visible = true;
				box.flipX = false;
			case 'gfcheer':
				portraitLeft.visible = false;
				remove(portraitRight);
				portraitRight = new FlxSprite(800, 80).loadGraphic(Paths.image('portraits/gfportrait', 'fueg0'));
				//portraitRight.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				add(portraitRight);
				portraitRight.visible = true;
				box.flipX = false;
			case 'gftalk':
				portraitLeft.visible = false;
				remove(portraitRight);
				portraitRight = new FlxSprite(800, 80).loadGraphic(Paths.image('portraits/gftalking', 'fueg0'));
				//portraitRight.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				add(portraitRight);
				portraitRight.visible = true;
				box.flipX = false;
			case 'bf':
				portraitLeft.visible = false;
				remove(portraitRight);
				portraitRight = new FlxSprite(800, 80).loadGraphic(Paths.image('portraits/bfportrait', 'fueg0'));
				//portraitRight.setGraphicSize(Std.int(portraitLeft.width * 0.4));
				add(portraitRight);
				portraitRight.visible = true;
				box.flipX = false;
			case 'none':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = false;
					box.flipX = false;
					//portraitRight.animation.play('enter');
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
