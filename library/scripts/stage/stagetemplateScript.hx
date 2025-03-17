// API Script for Stage Template

// Credits to Kactus for his token code!! as well as Tek for his Text Generator!! and also Donut for his soundeffect replacement code thing in aomori!! thank you guys!!!

// p.s. this code can be really spaghetti at times. be warned

var hitSoundArray = ["light", "medium", "heavy"];

var namesToReplace = ["thewatcher", "ronaldmc", "MugenDK", "kungfuman", "3-marios", "BezPez", "bdpgoinfast", "Tager", "DSSasquatch", "paperMario", "AnShiraishi", "ShihoHinomori", "EnaShinonome", "HarukaKiritani", "EmuOtori", "MUGENMARIO", "dongdongCharEntity", "ChunLi", "jinkazama", "cfalcon113", "MGW", "annieCharacter", "characterSaber", "characterHibiki", "CrashBandicoot", "darklenny", "ParaWaddleDee", "DonaldDuck", "thecar", "KimPine", "FeaturingDemiFiendFromSMT", "ScratchCat", "MINIMARIODSF", "talkingflower", "QuestionBlock", "AlienHominid", "meleefox", "pitpm", "darkpit", "mamacoco", "MamaCoco", "InvLuigi", "7granddad", "Ky", "kyo", "RockHoward", "MCDoor", "grassblock", "unocard", "characterZero", "LilithAensland", "NScott", "mayChar", "originsluca", "MorriganAensland", "BatmanDC", "meltybloodhisui", "IbukiSuika"];

var nameReplacements = ["the watcher", "ronald mcdonald", "donkey kong", "kung fu man", "three marios", "bezel", "sonic", "Iron Tager", "Sasquatch", "paper mario", "an shiraishi", "shiho hinomori", "ena shinonome", "haruka kiritani", "emu otori", "Mario", "dong dong", "chun li", "jin kazama", "captain falcon", "mr game and watch", "annie", "saber", "hibiki", "crash bandicoot", "dark lenny", "parasol waddle dee", "donald duck", "car", "kim pine", "demifiend", "scratch cat", "mini mario", "talking flower", "question block", "alien hominid", "melee fox", "pit pm", "dark pit", "mama coco", "Mama Coco", "invincible luigi", "grand dad", "ky kiske", "kyo kusanagi", "rock howard", "door", "grass block", "uno card", "zero", "lilith aensland", "negascott", "may", "origins luca", "morrigan aensland", "batman", "hisui", "ibuki suika"];

var noFlyList = ["ronaldmc", "Cowboy"];
var listOfAllNonExistentPeople = ["p"];

var textSprites: Array<Sprites> = [];

var frames_left = 10;

var players = [];
var mugenTimer:Vfx = null;
var fightText:Vfx = null;
var koText:Vfx = null;
var blackScreen:Sprite = null;
var roundNumber = self.makeInt(1);
var debounce = false;

var blastZone = new Rectangle((self.getDeathBounds().getX() + 30), (self.getDeathBounds().getY() - 30), (self.getDeathBounds().getRectangle().width - 30), (self.getDeathBounds().getRectangle().height - 30));


var lastState:number = 0;
var lastStateClone:number = 0;

var playerNegative1:Character = null;
var playerNegative2:Character = null;

var p1debounce = false;
var p2debounce = false;
var p3debounce = false;
var p4debounce = false;

var player1:Character = null;
var player1Token:Vfx = null;
var player1TokenHud:Vfx = null;
var player1LifeBar:Sprite = null;
var player1Meter:Sprite = null;
var player1FirstWin:Sprite = null;
var player1SecondWin:Sprite = null;
var player1Reflectance:Vfx = null;


// do not ask what 'side' means for i cannot answer

var p1SideCombo:number = 0;
var p2SideCombo:number = 0;
var p3SideCombo:number = 0;
var p4SideCombo:number = 0;

var player1SideComboVisuals:Sprite = null;
var player2SideComboVisuals:Sprite = null;
var player3SideComboVisuals:Sprite = null;
var player4SideComboVisuals:Sprite = null;

var p1Wins:number = 0;
var p2Wins:number = 0;

var player2:Character = null;
var player2Token:Vfx = null;
var player2TokenHud:Vfx = null;
var player2LifeBar:Sprite = null;
var player2Meter:Sprite = null;
var player2FirstWin:Sprite = null;
var player2SecondWin:Sprite = null;

var player3:Character = null;
var player3Token:Vfx = null;
var player3TokenHud:Vfx = null;
var player3Meter:Sprite = null;

var team1LifeBarContainerSprite:Sprite = null;
var team1Player1LifeBar:Sprite = null;
var team1Player3LifeBar:Sprite = null;

var team2LifeBarContainerSprite:Sprite = null;
var team2Player2LifeBar:Sprite = null;
var team2Player4LifeBar:Sprite = null;


var team1FirstWin:Sprite = null;
var team1SecondWin:Sprite = null;

var player4:Character = null;
var player4Token:Vfx = null;
var player4TokenHud:Vfx = null;
var player4Meter:Sprite = null;

var team2FirstWin:Sprite = null;
var team2SecondWin:Sprite = null;

var teams_isPlayer1KOd = false;
var teams_isPlayer2KOd = false;
var teams_isPlayer3KOd = false;
var teams_isPlayer4KOd = false;


var moveCooldown = self.makeObject(null);
var actualMoveCD = self.makeObject(null);
var stateToDisable = self.makeInt(null);

function initialize(){
	// Don't animate the stage itself (we'll pause on one version for hazards on, and another version for hazards off)
	self.pause();

    
	match.getMatchSettingsConfig().lives = 2;
	match.getMatchSettingsConfig().damageRatio = 0.85;


	mugenTimer = match.createVfx(new VfxStats({
					spriteContent: self.getResource().getContent("mountainsidetemple"),
					animation: "infiniteTimer",
					x:319,
					scaleX:0.5,
					scaleY:0.5,
					y:25,
				}));
	mugenTimer.playFrame(1);
	mugenTimer.pause();
	camera.getForegroundContainer().addChild(mugenTimer.getViewRootContainer());

	if (match.getMatchSettingsConfig().hazards) {
		// Hazards are on, enable the platform beneath the stage
		match.createStructure(self.getResource().getContent("stagetemplateMovingPlatform"));
		self.playLabel("hazardson");
	}

}

function reverseString(str:string) {
    var result = "";
    for (i in 0...str.length) {
        result = str.charAt(i) + result;
    }
    return result;
}

function contentIdMatchesInList(target:string) {
    return namesToReplace.indexOf(target) != -1; 
}

function idMatchesInNoFlyList(target:string) {
    return noFlyList.indexOf(target) != -1; 
}

function isSpectator(target:string) {
    return listOfAllNonExistentPeople.indexOf(target) != -1; 
}

function handleNames(namey:string){
    if (contentIdMatchesInList(namey)) {
        var sexyNumber = namesToReplace.indexOf(namey);

        return nameReplacements[sexyNumber];
    } else {
        return namey;
    }
}

// skip to line 900 to avoid looking at these functions

function disposeSprites(textSprites: Array<Sprite>) {
    Engine.forEach(textSprites, function (sprite: Sprite, idx: Int) {
        sprite.dispose();
        return true;
    }, []);
    textSprites = [];
}

function createLifeBarSpriteFromCharacter(char: String): Sprite {
    var res = self.getResource().getContent("lifebarText");
    var lowerCase = "abcdefghijklmnopqrstuvwxyz";
    var upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var digits = "0123456789";
    var symbols = "!\"#$%&'()*+,-./;<=>?@:[\\]^_`{|}~ ";

    var lowerCaseIndex = lowerCase.indexOf(char);
    var upperCaseIndex = upperCase.indexOf(char);
    var digitIndex = digits.indexOf(char);
    var symbolIndex = symbols.indexOf(char);

    var isDigit = digitIndex >= 0;
    var isLowerCase = lowerCaseIndex >= 0;
    var isUpperCase = upperCaseIndex >= 0;
    var isSymbol = symbolIndex >= 0;

    var sprite: Sprite = Sprite.create(res);
    if (isDigit) {
        sprite.currentAnimation = "digits";
        sprite.currentFrame = digitIndex + 1;
    } else if (isSymbol) {
        sprite.currentAnimation = "symbols";
        sprite.currentFrame = symbolIndex + 1;
    } else if (isLowerCase) {
        sprite.currentAnimation = "lowercase";
        sprite.currentFrame = lowerCaseIndex + 1;
    } else if (isUpperCase) {
        sprite.currentAnimation = "uppercase";
        sprite.currentFrame = upperCaseIndex + 1;
    } else {
        sprite.currentAnimation = "symbols";
        sprite.currentFrame = symbols.length - 1;
    }

    return sprite;
}

function createSpriteFromCharacter(char: String): Sprite {
    var res = self.getResource().getContent("text");
    var lowerCase = "abcdefghijklmnopqrstuvwxyz";
    var upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    var digits = "0123456789";
    var symbols = "!\"#$%&'()*+,-./;<=>?@:[\\]^_`{|}~ ";

    var lowerCaseIndex = lowerCase.indexOf(char);
    var upperCaseIndex = upperCase.indexOf(char);
    var digitIndex = digits.indexOf(char);
    var symbolIndex = symbols.indexOf(char);

    var isDigit = digitIndex >= 0;
    var isLowerCase = lowerCaseIndex >= 0;
    var isUpperCase = upperCaseIndex >= 0;
    var isSymbol = symbolIndex >= 0;

    var sprite: Sprite = Sprite.create(res);
    if (isDigit) {
        sprite.currentAnimation = "digits";
        sprite.currentFrame = digitIndex + 1;
    } else if (isSymbol) {
        sprite.currentAnimation = "symbols";
        sprite.currentFrame = symbolIndex + 1;
    } else if (isLowerCase) {
        sprite.currentAnimation = "lowercase";
        sprite.currentFrame = lowerCaseIndex + 1;
    } else if (isUpperCase) {
        sprite.currentAnimation = "uppercase";
        sprite.currentFrame = upperCaseIndex + 1;
    } else {
        sprite.currentAnimation = "symbols";
        sprite.currentFrame = symbols.length - 1;
    }

    return sprite;
}

function parseHexCode(hex: String): Int {
    var total: Int = 0;
    hex = hex.toUpperCase();
    var digits = "0123456789ABCDEF";
    var numPart = hex.substr(1);
    var idx = 0;
    while (idx < numPart.length) {
        var power = numPart.length - idx - 1;
        var num = digits.indexOf(numPart.charAt(idx));
        total += Math.round(num * Math.pow(16, power));
        idx++;
    }
    return total;
}

function syntaxError(text: String, curr: Int): { text: String, color: Int, error: Bool, length: Int } {
    var errorMessage: String = [
        "Error Rendering Text: \nUnexpected character ",
        ("\"" + text.charAt(curr) + "\""),
        "\nat character position ", curr.toString()].join("");
    Engine.log(errorMessage, 0xFFC300);
    return {
        error: true,
        color: 0xFF0000,
        text: errorMessage
    };
}

function parseTag(text: String, curr: Int): { text: String, color: Int, error: Bool, length: Int } {
    var color = 0;
    var content = "";

    if ("<" == text.charAt(curr)) { curr++; } else { return syntaxError(text, curr); }

    while (text.charAt(curr) == " ") { curr++; }

    if (text.charAt(curr) == "#") {
        var hexString = "#";
        var nums = "0123456789ABCDEFabcdef";
        curr++;
        while (nums.indexOf(text.charAt(curr)) >= 0) {
            hexString += text.charAt(curr);
            curr++;
        }
        color = parseHexCode(hexString);
    } else { return syntaxError(text, curr); }

    while (text.charAt(curr) == " ") { curr++; }

    if (text.charAt(curr) == ">") { curr++; } else { return syntaxError(text, curr); }

    while (text.charAt(curr) != "<") {
        if (text.charAt(curr) == "\\" && curr + 2 < text.length) {
            content += text.charAt(curr + 1);
            curr += 2;
        } else {
            content += text.charAt(curr);
            curr++;
        }
    }

    if (text.charAt(curr) == "<") { curr++; } else { return syntaxError(text, curr); };

    if (text.charAt(curr) == "/") { curr++; } else { return syntaxError(text, curr); };

    if (text.charAt(curr) == ">") { curr++; } else { return syntaxError(text, curr); };

    return { color: color, text: content, length: curr };
}

function parseText(text: String): Array<{ text: String, color: Int, error: Bool, length: Int }> {
    var nodes: Array<{ text: String, color: Int, error: Bool, length: Int }> = [];
    var curr = 0;
    var nodeIdx = 0;
    while (curr < text.length) {
        if (nodes[nodeIdx] == null) {
            nodes[nodeIdx] = {
                text: "",
                color: 0xFFFFFF,
                length: 0,
                error: false
            };
        }

        switch (text.charAt(curr)) {
            case "\\": {
                if (curr + 2 < text.length) {
                    nodes[nodeIdx].text += text.charAt(curr + 1);
                    nodes[nodeIdx].length += 1;
                    curr += 2;
                } else {
                    nodes.push(syntaxError(text, curr));
                    break;
                }
            };
            case "<": {
                nodeIdx++;
                var result = parseTag(text, curr);
                if (!result.error) {
                    curr = result.length;
                    nodes[nodeIdx] = result;
                    nodes[nodeIdx].color = result.color;
                    nodeIdx++;
                } else {
                    nodes[nodeIdx] = result;
                    break;
                }
            };
            default: {
                nodes[nodeIdx].text += text.charAt(curr);
                nodes[nodeIdx].length += 1;
                curr++;
            };

        }
    }
    return nodes;
}

function renderText(
    text: String,
    sprites: Array<Sprite>,
    container: Container,
    options: { autoLinewrap: Int, delay: Int, x: Int, y: Int, owner: Entity }
): { duration: Int, sprites: Array<Sprite> } {
    var parsed: Array<{ text: String, color: Float, error: Boolean, length: number }> = parseText(text);
    disposeSprites(sprites);

    sprites = [];
    var line = 0;
    var col = 0;

    function makeSprite(char: String, shaderOptions: { color: Int }) {
        if (options != null && options.autoLinewrap > 0 && options.autoLinewrap < col && !options.wordWrap) {
            col = 0;
            line++;
        }
        var sprite: Sprite = createSpriteFromCharacter(char);
        sprite.scaleX = 0.5;
        sprite.scaleY = 0.5;
        sprite.x = col * 16.5;
        if (options != null && options.x != null) {
            sprite.x += options.x;
        }
        sprite.y = line * 40;
        if (options != null && options.y != null) {
            sprite.y += options.y;
        }
        //var shader:RgbaColorShader = createColorShader(shaderOptions.color);  <--- must remove this to make the text generator work for some reason
        //sprite.addShader(shader);
        return sprite;
    }

    Engine.forEach(parsed, function (node: {
        text: String, color: Int, error: Boolean, length: number
    }, _: Int) {
        Engine.forCount(node.text.length, function (idx: Int) {
            var char: String = node.text.charAt(idx);
            if (char == "\n") {
                line++;
                col = 0;
            } else {
                var sprite = makeSprite(char, { color: node.color });
                sprites.push(sprite);
                col++;
            }
            return true;
        }, []);
        return true;
    }, []);

    var owner = self;
    if (options.owner != null) {
        owner = options.owner;
    }

    if (options.delay != null && options.delay > 0) {
        Engine.forEach(sprites, function (sprite: Sprite, idx: Int) {
            owner.addTimer(idx * options.delay, 1, function () {
                container.addChild(sprite);
            }, { persistent: true });
            return true;
        }, []);

        return { sprites: sprites, duration: sprites.length * options.delay };
    } else {
        Engine.forEach(sprites, function (sprite: Sprite, _idx: Int) {
            container.addChild(sprite);
            return true;
        }, []);

        return { sprites: sprites, duration: -1 };
    }
}

function renderLifeBarText(
    text: String,
    sprites: Array<Sprite>,
    container: Container,
    options: { autoLinewrap: Int, delay: Int, x: Int, y: Int, owner: Entity }
): { duration: Int, sprites: Array<Sprite> } {
    var parsed: Array<{ text: String, color: Float, error: Boolean, length: number }> = parseText(text);
    disposeSprites(sprites);

    sprites = [];
    var line = 0;
    var col = 0;

    function makeSprite(char: String, shaderOptions: { color: Int }) {
        if (options != null && options.autoLinewrap > 0 && options.autoLinewrap < col && !options.wordWrap) {
            col = 0;
            line++;
        }
        var sprite: Sprite = createLifeBarSpriteFromCharacter(char);
        sprite.x = col * 8.5;
        if (options != null && options.x != null) {
            sprite.x += options.x;
        }
        sprite.y = line * 40;
        if (options != null && options.y != null) {
            sprite.y += options.y;
        }
        //var shader:RgbaColorShader = createColorShader(shaderOptions.color);  <--- must remove this to make the text generator work for some reason
        //sprite.addShader(shader);
        return sprite;
    }

    Engine.forEach(parsed, function (node: {
        text: String, color: Int, error: Boolean, length: number
    }, _: Int) {
        Engine.forCount(node.text.length, function (idx: Int) {
            var char: String = node.text.charAt(idx);
            if (char == "\n") {
                line++;
                col = 0;
            } else {
                var sprite = makeSprite(char, { color: node.color });
                sprites.push(sprite);
                col++;
            }
            return true;
        }, []);
        return true;
    }, []);

    var owner = self;
    if (options.owner != null) {
        owner = options.owner;
    }

    if (options.delay != null && options.delay > 0) {
        Engine.forEach(sprites, function (sprite: Sprite, idx: Int) {
            owner.addTimer(idx * options.delay, 1, function () {
                container.addChild(sprite);
            }, { persistent: true });
            return true;
        }, []);

        return { sprites: sprites, duration: sprites.length * options.delay };
    } else {
        Engine.forEach(sprites, function (sprite: Sprite, _idx: Int) {
            container.addChild(sprite);
            return true;
        }, []);

        return { sprites: sprites, duration: -1 };
    }
}

function renderLifeBarText(
    text: String,
    sprites: Array<Sprite>,
    container: Container,
    options: {autoLinewrap: Int, delay: Int, x: Int, y: Int, owner: Entity }
): { duration: Int, sprites: Array<Sprite> } {
    var parsed: Array<{ text: String, color: Float, error: Boolean, length: number }> = parseText(text);
    disposeSprites(sprites);

    sprites = [];
    var line = 0;
    var col = 0;

    function makeSprite(char: String, shaderOptions: { color: Int }) {
        if (options != null && options.autoLinewrap > 0 && options.autoLinewrap < col && !options.wordWrap) {
            col = 0;
            line++;
        }
        var sprite: Sprite = createLifeBarSpriteFromCharacter(char);
        sprite.x = col * 8.5;
        if (options != null && options.x != null) {
            sprite.x += options.x;
        }
        sprite.y = line * 40;
        if (options != null && options.y != null) {
            sprite.y += options.y;
        }
        //var shader:RgbaColorShader = createColorShader(shaderOptions.color);  <--- must remove this to make the text generator work for some reason
        //sprite.addShader(shader);
        return sprite;
    }

    Engine.forEach(parsed, function (node: {
        text: String, color: Int, error: Boolean, length: number
    }, _: Int) {
        Engine.forCount(node.text.length, function (idx: Int) {
            var char: String = node.text.charAt(idx);
            if (char == "\n") {
                line++;
                col = 0;
            } else {
                var sprite = makeSprite(char, { color: node.color });
                sprites.push(sprite);
                col++;
            }
            return true;
        }, []);
        return true;
    }, []);

    var owner = self;
    if (options.owner != null) {
        owner = options.owner;
    }

    if (options.delay != null && options.delay > 0) {
        Engine.forEach(sprites, function (sprite: Sprite, idx: Int) {
            owner.addTimer(idx * options.delay, 1, function () {
                container.addChild(sprite);
            }, { persistent: true });
            return true;
        }, []);

        return { sprites: sprites, duration: sprites.length * options.delay };
    } else {
        Engine.forEach(sprites, function (sprite: Sprite, _idx: Int) {
            container.addChild(sprite);
            return true;
        }, []);

        return { sprites: sprites, duration: -1 };
    }
}

function renderSmallLifeBarText(
    text: String,
    sprites: Array<Sprite>,
    container: Container,
    options: {autoLinewrap: Int, delay: Int, x: Int, y: Int, owner: Entity }
): { duration: Int, sprites: Array<Sprite> } {
    var parsed: Array<{ text: String, color: Float, error: Boolean, length: number }> = parseText(text);
    disposeSprites(sprites);

    sprites = [];
    var line = 0;
    var col = 0;

    function makeSprite(char: String, shaderOptions: { color: Int }) {
        if (options != null && options.autoLinewrap > 0 && options.autoLinewrap < col && !options.wordWrap) {
            col = 0;
            line++;
        }
        var sprite: Sprite = createLifeBarSpriteFromCharacter(char);
        sprite.scaleX = 0.5;
        sprite.scaleY = 0.8;

        sprite.x = col * 4.25;
        if (options != null && options.x != null) {
            sprite.x += options.x;
        }
        sprite.y = line * 40;
        if (options != null && options.y != null) {
            sprite.y += options.y;
        }
        //var shader:RgbaColorShader = createColorShader(shaderOptions.color);  <--- must remove this to make the text generator work for some reason
        //sprite.addShader(shader);
        return sprite;
    }

    Engine.forEach(parsed, function (node: {
        text: String, color: Int, error: Boolean, length: number
    }, _: Int) {
        Engine.forCount(node.text.length, function (idx: Int) {
            var char: String = node.text.charAt(idx);
            if (char == "\n") {
                line++;
                col = 0;
            } else {
                var sprite = makeSprite(char, { color: node.color });
                sprites.push(sprite);
                col++;
            }
            return true;
        }, []);
        return true;
    }, []);

    var owner = self;
    if (options.owner != null) {
        owner = options.owner;
    }

    if (options.delay != null && options.delay > 0) {
        Engine.forEach(sprites, function (sprite: Sprite, idx: Int) {
            owner.addTimer(idx * options.delay, 1, function () {
                container.addChild(sprite);
            }, { persistent: true });
            return true;
        }, []);

        return { sprites: sprites, duration: sprites.length * options.delay };
    } else {
        Engine.forEach(sprites, function (sprite: Sprite, _idx: Int) {
            container.addChild(sprite);
            return true;
        }, []);

        return { sprites: sprites, duration: -1 };
    }
}

function renderBigLifeBarText(
    text: String,
    sprites: Array<Sprite>,
    container: Container,
    options: {autoLinewrap: Int, delay: Int, x: Int, y: Int, owner: Entity }
): { duration: Int, sprites: Array<Sprite> } {
    var parsed: Array<{ text: String, color: Float, error: Boolean, length: number }> = parseText(text);
    disposeSprites(sprites);

    sprites = [];
    var line = 0;
    var col = 0;

    function makeSprite(char: String, shaderOptions: { color: Int }) {
        if (options != null && options.autoLinewrap > 0 && options.autoLinewrap < col && !options.wordWrap) {
            col = 0;
            line++;
        }
        var sprite: Sprite = createLifeBarSpriteFromCharacter(char);
        sprite.scaleX = 2;
        sprite.scaleY = 2;

        sprite.x = col * 17;
        if (options != null && options.x != null) {
            sprite.x += options.x;
        }
        sprite.y = line * 40;
        if (options != null && options.y != null) {
            sprite.y += options.y;
        }
        //var shader:RgbaColorShader = createColorShader(shaderOptions.color);  <--- must remove this to make the text generator work for some reason
        //sprite.addShader(shader);
        return sprite;
    }

    Engine.forEach(parsed, function (node: {
        text: String, color: Int, error: Boolean, length: number
    }, _: Int) {
        Engine.forCount(node.text.length, function (idx: Int) {
            var char: String = node.text.charAt(idx);
            if (char == "\n") {
                line++;
                col = 0;
            } else {
                var sprite = makeSprite(char, { color: node.color });
                sprites.push(sprite);
                col++;
            }
            return true;
        }, []);
        return true;
    }, []);

    var owner = self;
    if (options.owner != null) {
        owner = options.owner;
    }

    if (options.delay != null && options.delay > 0) {
        Engine.forEach(sprites, function (sprite: Sprite, idx: Int) {
            owner.addTimer(idx * options.delay, 1, function () {
                container.addChild(sprite);
            }, { persistent: true });
            return true;
        }, []);

        return { sprites: sprites, duration: sprites.length * options.delay };
    } else {
        Engine.forEach(sprites, function (sprite: Sprite, _idx: Int) {
            container.addChild(sprite);
            return true;
        }, []);

        return { sprites: sprites, duration: -1 };
    }
}

function renderEvilLifeBarText(
    text: String,
    sprites: Array<Sprite>,
    container: Container,
    options: { scaleX:Float, scaleY: Float, kerning:Float, autoLinewrap: Int, delay: Int, x: Int, y: Int, owner: Entity }
): { duration: Int, sprites: Array<Sprite> } {
    var parsed: Array<{ text: String, color: Float, error: Boolean, length: number }> = parseText(text);
    disposeSprites(sprites);

    sprites = [];
    var line = 0;
    var col = 0;

    function makeSprite(char: String, shaderOptions: { color: Int }) {
        if (options != null && options.autoLinewrap > 0 && options.autoLinewrap < col && !options.wordWrap) {
            col = 0;
            line++;
        }
        var sprite: Sprite = createLifeBarSpriteFromCharacter(char);
        sprite.x = col * -8.5;
        if (options != null && options.x != null) {
            sprite.x += options.x;
        }
        sprite.y = line * 40;
        if (options != null && options.y != null) {
            sprite.y += options.y;
        }
        //var shader:RgbaColorShader = createColorShader(shaderOptions.color);   <--- must remove this to make the text generator work for some reason
        //sprite.addShader(shader);
        return sprite;
    }

    Engine.forEach(parsed, function (node: {
        text: String, color: Int, error: Boolean, length: number
    }, _: Int) {
        Engine.forCount(node.text.length, function (idx: Int) {
            var char: String = node.text.charAt(idx);
            if (char == "\n") {
                line++;
                col = 0;
            } else {
                var sprite = makeSprite(char, { color: node.color });
                sprites.push(sprite);
                col++;
            }
            return true;
        }, []);
        return true;
    }, []);

    var owner = self;
    if (options.owner != null) {
        owner = options.owner;
    }

    if (options.delay != null && options.delay > 0) {
        Engine.forEach(sprites, function (sprite: Sprite, idx: Int) {
            owner.addTimer(idx * options.delay, 1, function () {
                container.addChild(sprite);
            }, { persistent: true });
            return true;
        }, []);

        return { sprites: sprites, duration: sprites.length * options.delay };
    } else {
        Engine.forEach(sprites, function (sprite: Sprite, _idx: Int) {
            container.addChild(sprite);
            return true;
        }, []);

        return { sprites: sprites, duration: -1 };
    }
}

function renderSmallEvilLifeBarText(
    text: String,
    sprites: Array<Sprite>,
    container: Container,
    options: { scaleX:Float, scaleY: Float, kerning:Float, autoLinewrap: Int, delay: Int, x: Int, y: Int, owner: Entity }
): { duration: Int, sprites: Array<Sprite> } {
    var parsed: Array<{ text: String, color: Float, error: Boolean, length: number }> = parseText(text);
    disposeSprites(sprites);

    sprites = [];
    var line = 0;
    var col = 0;

    function makeSprite(char: String, shaderOptions: { color: Int }) {
        if (options != null && options.autoLinewrap > 0 && options.autoLinewrap < col && !options.wordWrap) {
            col = 0;
            line++;
        }
        var sprite: Sprite = createLifeBarSpriteFromCharacter(char);
        sprite.scaleX = 0.5;
        sprite.scaleY = 0.8;

        sprite.x = col * -4.25;
        if (options != null && options.x != null) {
            sprite.x += options.x;
        }
        sprite.y = line * 40;
        if (options != null && options.y != null) {
            sprite.y += options.y;
        }
        //var shader:RgbaColorShader = createColorShader(shaderOptions.color);   <--- must remove this to make the text generator work for some reason
        //sprite.addShader(shader);
        return sprite;
    }

    Engine.forEach(parsed, function (node: {
        text: String, color: Int, error: Boolean, length: number
    }, _: Int) {
        Engine.forCount(node.text.length, function (idx: Int) {
            var char: String = node.text.charAt(idx);
            if (char == "\n") {
                line++;
                col = 0;
            } else {
                var sprite = makeSprite(char, { color: node.color });
                sprites.push(sprite);
                col++;
            }
            return true;
        }, []);
        return true;
    }, []);

    var owner = self;
    if (options.owner != null) {
        owner = options.owner;
    }

    if (options.delay != null && options.delay > 0) {
        Engine.forEach(sprites, function (sprite: Sprite, idx: Int) {
            owner.addTimer(idx * options.delay, 1, function () {
                container.addChild(sprite);
            }, { persistent: true });
            return true;
        }, []);

        return { sprites: sprites, duration: sprites.length * options.delay };
    } else {
        Engine.forEach(sprites, function (sprite: Sprite, _idx: Int) {
            container.addChild(sprite);
            return true;
        }, []);

        return { sprites: sprites, duration: -1 };
    }
}



function renderLines(lines: Array<String>,
    sprites: Array<Sprite>,
    container: Container,
    options: { delay: Int, x: Int, y: Int }): { duration: Int, sprites: Array<Sprite>, owner: Entity } {
    var renderData = renderText(lines.join("\n"), sprites, container, { autoLinewrap: false, delay: delay, x: options.x, y: options.y, owner: options.owner });
    return renderData;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*

might revisit this in the future!

function squeakyCleanFloor(char:Character) {
    switch(char) {
        case player1:
            player1Reflectance = match.createVfx(new VfxStats({
				spriteContent: player1.getResource().getContent(player1.getPlayerConfig().character.contentId),
				animation: "stand",
				x: player1.getX() + 165,
                y: player1.getY(),
                scaleX:player1.getGameObjectStat("baseScaleX"),
                scaleY:player1.getGameObjectStat("baseScaleY")*-1,
				}));
            player1Reflectance.playFrame(1);
            player1Reflectance.pause();
            player1Reflectance.setAlpha(0.5);
            player1Reflectance.addShader(player1.getCostumeShader());
            Engine.log(player1.getScaleX());
			self.getCharactersBackContainer().addChild(player1Reflectance.getViewRootContainer());

            player1.addTimer(1,-1,function(){
                player1Reflectance.playAnimation(player1.getAnimation());
                player1Reflectance.playFrame(player1.getCurrentFrame());
                player1Reflectance.setX(player1.getX());
                player1Reflectance.setY(player1.getY()*-1 + 255);
                player1Reflectance.setYVelocity(-1*player1.getYVelocity());
                if (player1.isFacingRight()){
                    player1Reflectance.faceRight();
                } else {
                    player1Reflectance.faceLeft();
                }
            }, {persistent:true});
    }
}*/

function checkIfOutOfBounds(char:Character) {
    if (!blastZone.contains(char.getX(), char.getY())){
        char.setX(0);
        char.setY(0);
        Engine.log("Character has gone out of bounds.");
    }
}

function koLogic(winner:Int) {

    for (plr in players) {
        plr.applyGlobalBodyStatus(BodyStatus.INVINCIBLE, 200);
    }
    AudioClip.play(self.getResource().getContent("ko"), {channel:"announcer", volume:2.5});

            koText = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "ko",
							x: 305,
                            y: 175.5,
                            scaleX:0.425,
                            scaleY:0.425
						}));
			koText.playFrame(1);
            koText.pause();
			camera.getForegroundContainer().addChild(koText.getViewRootContainer());

            if (blackScreen == null) {
            blackScreen = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			blackScreen.currentAnimation = "blackscreen";
			blackScreen.currentFrame = 201;
			blackScreen.x = 305;
			blackScreen.y = 175.5;
			blackScreen.scaleX = 3;
			blackScreen.scaleY = 3;
            blackScreen.alpha = 0;
			camera.getForegroundContainer().addChild(blackScreen);
            }

            player1.addTimer(45,1,function(){
                camera.getForegroundContainer().removeChild(koText.getViewRootContainer());
                koText = null;

                player1.addTimer(30,1,function(){

                // this is how... a real man codes

                player1.addTimer(30,1,function(){
                    player1.addTimer(1,50,function(){
                        blackScreen.alpha += 0.02;
                    }, {persistent:true});
                }, {persistent:true});

                switch(winner) {
                    case 1: //p1 win

                        var squiggy = renderBigLifeBarText("" + handleNames(player1.getPlayerConfig().character.contentId) + " \nWIN",
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 265,
                              y: 175.5,
                            }); 
                        player1.addTimer(40,1,function(){
                            for (textthing in squiggy.sprites) {
                                textthing.dispose();
                            }
                        }, {persistent:true});

                    case 2: //p2 win
                        var squiggy = renderBigLifeBarText("" + handleNames(player2.getPlayerConfig().character.contentId) + " \nWIN",
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 265,
                              y: 175.5,
                            }); 
                        player1.addTimer(40,1,function(){
                            for (textthing in squiggy.sprites) {
                                textthing.dispose();
                            }
                        }, {persistent:true});

                    case 3: //t1 win
                        var squiggy = renderBigLifeBarText("Team\n" + handleNames(player1.getPlayerConfig().character.contentId) + "\n" + handleNames(player3.getPlayerConfig().character.contentId) + "\nWIN",
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 265,
                              y: 135.5,
                            }); 
                        player1.addTimer(40,1,function(){
                            for (textthing in squiggy.sprites) {
                                textthing.dispose();
                            }
                        }, {persistent:true});

                    case 4: //t2 win
                        var squiggy = renderBigLifeBarText("Team\n" + handleNames(player2.getPlayerConfig().character.contentId) + "\n" + handleNames(player4.getPlayerConfig().character.contentId) + "\nWIN",
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 265,
                              y: 135.5,
                            }); 
                        player1.addTimer(40,1,function(){
                            for (textthing in squiggy.sprites) {
                                textthing.dispose();
                            }
                        }, {persistent:true});
                    default:
                        Engine.log("UMMMM IDK LMFAO.... LOLLLL!");
                }
            }, {persistent:true});

            }, {persistent:true});

            player1.addTimer(200,1,function(){
                roundNumber.add(1);

                //if (p1Wins >= 2) {
                    switch (winner) {
                        case 1:
                            player2.toState(CState.KO);
                        case 2:
                            player1.toState(CState.KO);
                        case 3:
                            player2.toState(CState.KO);
                            if (player4 != null) {
                            player4.toState(CState.KO);
                            }
                        case 4:
                            player1.toState(CState.KO);
                            player3.toState(CState.KO);     
                    }

                    switch (players.length) {
                case 2:
                    player1.setDamage(0);
                    player2.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    
                    player1.faceRight();
                    player2.faceLeft();

                    p1debounce = false;
                    p2debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                    }
                case 3:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                    }

                case 4:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);
                    player4.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);
                    player4.setX(61);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();
                    player4.faceLeft();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;
                    teams_isPlayer4KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;
                    p4debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                    }
            }
               // }
                /*if (p2Wins >= 2) {
                    switch (winner) {
                        case 1:
                            player2.toState(CState.KO);
                        case 2:
                            player1.toState(CState.KO);
                        case 3:
                            player2.toState(CState.KO);
                            if (player4 != null) {
                            player4.toState(CState.KO);
                            }
                        case 4:
                            player1.toState(CState.KO);
                            player3.toState(CState.KO);     
                    }
                }*/

                player1.addTimer(5,1,function(){
                blackScreen.alpha = 0;
                exterminateEarlyAccessUpdateZeroPointSevenPointSevenNewAssistCadenceFromCryptOfTheNecrodancerExclamationPoint();
                roundLogic();
                }, {persistent:true});
            }, {persistent:true});


}

// be warned for you're about to witness the most unoptimized code to ever grace humanity

// what was i cooking
// EDIT: NEVER MIND I WAS COOKING HEAT!!! SWITCHING ROUND NUMBERS CAME TO THE RESCUE!!!!!

function roundLogic() {

    switch (roundNumber.get()) {
        case 1:

            switch (players.length) {
                case 2:
                    player1.setDamage(0);
                    player2.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    
                    player1.faceRight();
                    player2.faceLeft();

                    p1debounce = false;
                    p2debounce = false;

                    for (plr in players) {
                            plr.addTimer(75, 1, function(){
                                plr.toState(CState.UNINITIALIZED, "stand"); 
                            }, {persistent:true});
                    }

                case 3:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;

                    for (plr in players) {
                            plr.addTimer(75, 1, function(){
                                plr.toState(CState.UNINITIALIZED, "stand"); 
                            }, {persistent:true});
                    }

                case 4:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);
                    player4.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);
                    player4.setX(61);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();
                    player4.faceLeft();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;
                    teams_isPlayer4KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;
                    p4debounce = false;

                    for (plr in players) {
                            plr.addTimer(75, 1, function(){
                                plr.toState(CState.UNINITIALIZED, "stand"); 
                            }, {persistent:true});
                    }
            }

            var roundTwoText = renderText("Round 1",
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 265,
                              y: 175.5,
                            }); 

            AudioClip.play(self.getResource().getContent("round1"), {channel:"announcer", volume:2});

            self.addTimer(75,1,function(){

            for (textthing in roundTwoText.sprites) {
                textthing.dispose();
            }

            self.addTimer(25,1,function(){

            AudioClip.play(self.getResource().getContent("fight"), {channel:"announcer", volume:2});

            for (plr in players) {
                        plr.toState(CState.STAND); 
            }


            fightText = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "fight",
							x: 305,
                            y: 175.5,
                            scaleX:0.425,
                            scaleY:0.425
						}));
			fightText.playFrame(1);
			camera.getForegroundContainer().addChild(fightText.getViewRootContainer());

            }, {persistent:true});

            player1.addTimer(72,1,function(){
                camera.getForegroundContainer().removeChild(fightText.getViewRootContainer());
                fightText = null;
            }, {persistent:true});

			
			
			}, {persistent:true});

        case 2:

                        switch (players.length) {
                case 2:
                    player1.setDamage(0);
                    player2.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);

                    player1.faceRight();
                    player2.faceLeft();

                    p1debounce = false;
                    p2debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }
                case 3:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }

                case 4:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);
                    player4.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);
                    player4.setX(61);
                    
                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();
                    player4.faceLeft();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;
                    teams_isPlayer4KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;
                    p4debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }
            }

        	var roundTwoText = renderText("Round 2",
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 265,
                              y: 175.5,
                            }); 

            AudioClip.play(self.getResource().getContent("round2"), {channel:"announcer", volume:2});

            player1.addTimer(75,1,function(){

            for (textthing in roundTwoText.sprites) {
                textthing.dispose();
            }

            player1.addTimer(25,1,function(){

            AudioClip.play(self.getResource().getContent("fight"), {channel:"announcer", volume:2});

            for (plr in players) {
                        plr.toState(CState.STAND); 
            }

            fightText = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "fight",
							x: 305,
                            y: 175.5,
                            scaleX:0.425,
                            scaleY:0.425
						}));
			fightText.playFrame(1);
			camera.getForegroundContainer().addChild(fightText.getViewRootContainer());

            }, {persistent:true});

            player1.addTimer(72,1,function(){
                camera.getForegroundContainer().removeChild(fightText.getViewRootContainer());
                fightText = null;
            }, {persistent:true});

			
			
			}, {persistent:true});

        case 3: 

            switch (players.length) {
                case 2:
                    player1.setDamage(0);
                    player2.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);

                    player1.faceRight();
                    player2.faceLeft();

                    p1debounce = false;
                    p2debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }
                case 3:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }

                case 4:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);
                    player4.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);
                    player4.setX(61);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();
                    player4.faceLeft();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;
                    teams_isPlayer4KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;
                    p4debounce = false;


                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }
            }

            var roundThreeText = renderText("Round " + roundNumber.get(),
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 265,
                              y: 175.5,
                            }); 

            AudioClip.play(self.getResource().getContent("round3"), {channel:"announcer", volume:2});

            player1.addTimer(80,1,function(){

            for (textthing in roundThreeText.sprites) {
                textthing.dispose();
            }

			AudioClip.play(self.getResource().getContent("fight"), {channel:"announcer", volume:2});

            for (plr in players) {
                        plr.toState(CState.STAND); 
            }


                        fightText = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "fight",
							x: 305,
                            y: 175.5,
                            scaleX:0.425,
                            scaleY:0.425
						}));
			fightText.playFrame(1);
			camera.getForegroundContainer().addChild(fightText.getViewRootContainer());

            player1.addTimer(47,1,function(){
                camera.getForegroundContainer().removeChild(fightText.getViewRootContainer());
                fightText = null;
            }, {persistent:true});
			
			
			}, {persistent:true});

        default:

        switch (players.length) {
                case 2:
                    player1.setDamage(0);
                    player2.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);

                    player1.faceRight();
                    player2.faceLeft();

                    p1debounce = false;
                    p2debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }
                case 3:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }

                case 4:
                    player1.setDamage(0);
                    player2.setDamage(0);
                    player3.setDamage(0);
                    player4.setDamage(0);

                    player1.setX(-164);
                    player2.setX(162);
                    player3.setX(-98);
                    player4.setX(61);

                    player1.faceRight();
                    player2.faceLeft();
                    player3.faceRight();
                    player4.faceLeft();

                    teams_isPlayer1KOd = false;
                    teams_isPlayer2KOd = false;
                    teams_isPlayer3KOd = false;
                    teams_isPlayer4KOd = false;

                    p1debounce = false;
                    p2debounce = false;
                    p3debounce = false;
                    p4debounce = false;

                    for (plr in players) {
                        plr.toState(CState.UNINITIALIZED, "stand"); 
                        plr.addTimer(1,20,function(){
                            plr.toState(CState.UNINITIALIZED);
                        }, {persistent:true});
                    }
            }

        var roundText = renderText("Round " + roundNumber.get(),
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 275,
                              y: 175.5,
                            }); 

            AudioClip.play(self.getResource().getContent("round3"), {channel:"announcer", volume:2});

            player1.addTimer(80,1,function(){

            for (textthing in roundText.sprites) {
                textthing.dispose();
            }

			AudioClip.play(self.getResource().getContent("fight"), {channel:"announcer", volume:2});

            for (plr in players) {
                        plr.toState(CState.STAND); 
            }

            fightText = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "fight",
							x: 305,
                            y: 175.5,
                            scaleX:0.425,
                            scaleY:0.425
						}));
			fightText.playFrame(1);
			camera.getForegroundContainer().addChild(fightText.getViewRootContainer());

            player1.addTimer(47,1,function(){
                camera.getForegroundContainer().removeChild(fightText.getViewRootContainer());
                fightText = null;
            }, {persistent:true});
			
			
			}, {persistent:true});

    }
}

function turbo(event: GameObjectEvent) {
    var p: Character = event.data.self;
    if (event.data.foe.getAnimationStat("bodyStatus") == BodyStatus.INTANGIBLE) {
        return;
    }
    if (player3 != null && event.data.foe.getTeam() == p.getTeam()) {
        return;
    }
    if (event.data.foe.getType() == EntityType.PROJECTILE){
        return;
    }

    p.updateAnimationStats({ interruptible: true });
}

function evilAssCooldownAdder(event:GameObjectEvent){

    if (event.data.foe.getRootOwner() == event.data.self) {
        return;
    }

	switch(event.data.self.getState()) {
		case CharacterActions.AERIAL_NEUTRAL:
			stateToDisable = CharacterActions.AERIAL_NEUTRAL;
		case CharacterActions.AERIAL_FORWARD:
			stateToDisable = CharacterActions.AERIAL_FORWARD;
		case CharacterActions.AERIAL_DOWN:
			stateToDisable = CharacterActions.AERIAL_DOWN;
		case CharacterActions.AERIAL_UP:
			stateToDisable = CharacterActions.AERIAL_UP;
		case CharacterActions.AERIAL_BACK:
			stateToDisable = CharacterActions.AERIAL_BACK;
		case CharacterActions.TILT_FORWARD:
			stateToDisable = CharacterActions.TILT_FORWARD;
		case CharacterActions.TILT_UP:
			stateToDisable = CharacterActions.TILT_UP;
		case CharacterActions.TILT_DOWN:
			stateToDisable = CharacterActions.TILT_DOWN;
		case CharacterActions.THROW_FORWARD:
			stateToDisable = CharacterActions.THROW_FORWARD;

			event.data.self.addTimer(1,100, function(){
				if (event.data.self.getState() == CState.GRAB) {
					event.data.self.toState(CState.STAND);
				}
			}, {persistent:true});

		case CharacterActions.THROW_UP:
			stateToDisable = CharacterActions.THROW_UP;

			event.data.self.addTimer(1,100, function(){
				if (event.data.self.getState() == CState.GRAB) {
					event.data.self.toState(CState.STAND);
				}
			}, {persistent:true});

		case CharacterActions.THROW_DOWN:
			stateToDisable = CharacterActions.THROW_DOWN;

			event.data.self.addTimer(1,100, function(){
				if (event.data.self.getState() == CState.GRAB) {
					event.data.self.toState(CState.STAND);
				}
			}, {persistent:true});

		case CharacterActions.THROW_BACK:
			stateToDisable = CharacterActions.THROW_BACK;

			event.data.self.addTimer(1,100, function(){
				if (event.data.self.getState() == CState.GRAB) {
					event.data.self.toState(CState.STAND);
				}
			}, {persistent:true});

		case CharacterActions.JAB:
			stateToDisable = CharacterActions.JAB;

			event.data.self.addTimer(60, 1, function(){
				if (event.data.self.getHeldControls().ATTACK) {
					event.data.self.setKnockback(4,140);
				}
			});
		case CharacterActions.SPECIAL_UP:
			stateToDisable = CharacterActions.SPECIAL_UP;
		case CharacterActions.SPECIAL_DOWN:
			stateToDisable = CharacterActions.SPECIAL_DOWN;
		case CharacterActions.SPECIAL_SIDE:
			stateToDisable = CharacterActions.SPECIAL_SIDE;
		case CharacterActions.SPECIAL_NEUTRAL:
			stateToDisable = CharacterActions.SPECIAL_NEUTRAL;
		case CharacterActions.STRONG_FORWARD:
			stateToDisable = CharacterActions.STRONG_FORWARD;
		case CharacterActions.STRONG_UP:
			stateToDisable = CharacterActions.STRONG_UP;
		case CState.STRONG_DOWN_ATTACK:

			stateToDisable = CState.STRONG_DOWN_ATTACK;

			event.data.self.addTimer(1,20, function(){
				if (event.data.self.getState() == CState.STRONG_DOWN_IN) {
					event.data.self.toState(CState.STAND);
				}
			}, {persistent:true});
		case CState.STRONG_UP_ATTACK:
			stateToDisable = CState.STRONG_UP_ATTACK;

						event.data.self.addTimer(1,35, function(){
				if (event.data.self.getState() == CState.STRONG_UP_IN) {
					event.data.self.toState(CState.STAND);
				}
			}, {persistent:true});
		case CState.STRONG_FORWARD_ATTACK:
			stateToDisable = CState.STRONG_FORWARD_ATTACK;

						event.data.self.addTimer(1,20, function(){
				if (event.data.self.getState() == CState.STRONG_FORWARD_IN) {
					event.data.self.toState(CState.STAND);
				}
			}, {persistent:true});
        case CharacterActions.DASH_ATTACK:
			stateToDisable = CharacterActions.DASH_ATTACK;
		default:
			stateToDisable = CharacterActions.LEDGE_ATTACK;
	}
		actualMoveCD.set(event.data.self.addStatusEffect(StatusEffectType.DISABLE_ACTION, stateToDisable));
		
		event.data.self.addTimer(60,1, function() {
    	event.data.self.removeStatusEffect(StatusEffectType.DISABLE_ACTION, actualMoveCD.get().id);
		}, {persistent:true});
		


};

function stamina(event:GameObjectEvent) {

	if (event.data.self.getDamage() >= 200) {
		//event.data.self.toState(CState.KO);
        event.data.self.applyGlobalBodyStatus(BodyStatus.INVINCIBLE, 180);

        Engine.log("" + p1debounce + "" + p2debounce + "" + p3debounce + "" + p4debounce);

        switch (event.data.self) {
            case player1: 

            if (p1debounce == true) {return;}
            p1debounce = true;

            if (players.length >= 3) {

                teams_isPlayer1KOd = true;

                switch (players.length) {
                    case 3:
                        if (teams_isPlayer3KOd == true) {
                            koLogic(2);
                        }
                    case 4:
                        if (teams_isPlayer3KOd == true) {
                            koLogic(4);
                        }
                }
                            
            } else {            
                if (!p2debounce) {
                koLogic(2);

                switch (player2FirstWin.currentFrame) {
                                case 1:
                                    player2FirstWin.currentFrame = Random.getInt(2,7);
                                    p2Wins += 1;
                                default: 
                                    player2SecondWin.currentFrame = Random.getInt(2,7);
                                    p2Wins += 1;
                            }
                } else if (p1debounce && p2debounce) {
                    Engine.log("wtf double ko!!!");

                    koLogic(1);

                        switch (player1FirstWin.currentFrame) {
                    case 1:
                        player1FirstWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                    default: 
                        player1SecondWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                    } 
                }
                                event.data.self.addTimer(1,90,function(){

			                    if (event.data.self.isOnFloor()){

                                            event.data.self.toState(CState.UNINITIALIZED, "crash_loop");

                
			                        } else {
			                    event.data.self.toState(CState.TUMBLE);
			                        }
			
			
		                        }, {persistent:true});
                                
                                event.data.self.addTimer(95,1,function(){

		                        event.data.self.setDamage(0);
		                        event.data.self.toState(CState.CRASH_GET_UP);
			
			
		                        }, {persistent:true});

                        }

            case player2:

            if (p2debounce == true) {return;}
            p2debounce = true;

            if (players.length == 3) {
                                koLogic(3);
                                switch (player1FirstWin.currentFrame) {
                                case 1:
                                    player1FirstWin.currentFrame = Random.getInt(2,7);
                                    p1Wins += 1;
                                default: 
                                    player1SecondWin.currentFrame = Random.getInt(2,7);
                                    p1Wins += 1;
                                }

                                event.data.self.addTimer(1,90,function(){

			                    if (event.data.self.isOnFloor()){

                                            event.data.self.toState(CState.UNINITIALIZED, "crash_loop");

                
			                        } else {
			                    event.data.self.toState(CState.TUMBLE);
			                        }
			
			
		                        }, {persistent:true});

            } else if (players.length == 4) {
                            	/*event.data.self.addTimer(95,1,function(){
		                        event.data.self.setDamage(0);
		                        event.data.self.toState(CState.CRASH_GET_UP);
			
			
		                        }, {persistent:true});*/

                            teams_isPlayer2KOd = true;

                            if (teams_isPlayer4KOd == true) {
                                koLogic(3);
                            }
                    }  else {
                    
                    if (!p1debounce) {
                        koLogic(1);

                        switch (player1FirstWin.currentFrame) {
                    case 1:
                        player1FirstWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                    default: 
                        player1SecondWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                    } 
                } else if (p1debounce && p2debounce) {
                    Engine.log("wtf double ko!!!");

                    koLogic(1);

                        switch (player1FirstWin.currentFrame) {
                    case 1:
                        player1FirstWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                    default: 
                        player1SecondWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                    } 
                }


                    event.data.self.addTimer(1,90,function(){

			if (event.data.self.isOnFloor()){

                    event.data.self.toState(CState.UNINITIALIZED, "crash_loop");

                
			} else {
			event.data.self.toState(CState.TUMBLE);
			}
			
			
		}, {persistent:true});

                    event.data.self.addTimer(95,1,function(){

		                        event.data.self.setDamage(0);
		                        //event.data.self.toState(CState.KO);
		                        event.data.self.toState(CState.CRASH_GET_UP);
			
			
		                        }, {persistent:true});

                }

            case player3:

                if (p3debounce == true) {return;}
                p3debounce = true;

                teams_isPlayer3KOd = true;

                switch (players.length) {
                    case 3:
                        if (teams_isPlayer1KOd == true) {
                            koLogic(2);
                        }
                    case 4:
                        if (teams_isPlayer1KOd == true) {
                            koLogic(4);
                        }

                }

            case player4:

                if (p4debounce == true) {return;}
                p4debounce = true;

                teams_isPlayer4KOd = true;

                if(teams_isPlayer2KOd == true) {
                    koLogic(3);
                }

                
            default:
                Engine.log("IDK Lol!");
        }

		event.data.self.addTimer(1,1,function(){

			switch(event.data.self.isFacingRight()){
				case true:
					event.data.self.setXKnockback(-6);
					event.data.self.setRotation(event.data.self.getRotation()-2);
				default:
					event.data.self.setXKnockback(6);
					event.data.self.setRotation(event.data.self.getRotation()+2);
			}
			event.data.self.setYKnockback(-14);
			event.data.self.toState(CState.TUMBLE);
			
		}, {persistent:true});


		event.data.self.move(0,10);
	}
}
function p1LifeBarUpdate(){
	player1LifeBar.currentFrame = 201 - player1.getDamage();
}

function p2LifeBarUpdate(){
	player2LifeBar.currentFrame = 201 - player2.getDamage();
}

function p1TeamLifeBarUpdate(){
	team1Player1LifeBar.currentFrame = 201 - player1.getDamage();
}

function p3TeamLifeBarUpdate(){
	team1Player3LifeBar.currentFrame = 201 - player3.getDamage();
}

function p2TeamLifeBarUpdate(){
	team2Player2LifeBar.currentFrame = 201 - player2.getDamage();
}

function p4TeamLifeBarUpdate(){
	team2Player4LifeBar.currentFrame = 201 - player4.getDamage();
}

function p1MeterUpdate(){
	player1Meter.currentFrame = Math.floor(player1.getAssistCharge()*100 + 1);
}

function p2MeterUpdate(){
	player2Meter.currentFrame = Math.floor(player2.getAssistCharge()*100 + 1);
}

function p3MeterUpdate(){
	player3Meter.currentFrame = Math.floor(player3.getAssistCharge()*100 + 1);
}

function p4MeterUpdate(){
	player4Meter.currentFrame = Math.floor(player4.getAssistCharge()*100 + 1);
}

function update(){
	
    self.exports = {
        mugen: function(){return true;},
        temporarilyDisableCancel: disableMoveCancel,
    };

	frames_left -= 1;
	if (frames_left == 0) {

        

		for (char in match.getCharacters()) {


			char.setDamage(0);

			char.getDamageCounterContainer().y = -1000;
			char.getDamageCounterRenderSprite().x = 50;

            if (isSpectator(char.getPlayerConfig().character.contentId)) {
                if (playerNegative1 == null) {
                    playerNegative1 = char;
                    playerNegative1.addTimer(120,40,function(){
                        playerNegative1.toState(CState.KO);
                    }, {persistent:true});
                }
                if (playerNegative1 != char && playerNegative2 == null) {
                    playerNegative2 = char;
                    playerNegative2.addTimer(120,40,function(){
                        playerNegative2.toState(CState.KO);
                    }, {persistent:true});
                }
            }

			if (player1 == null && playerNegative1 != char && playerNegative2 != char) {

			player1 = char;
            players.push(player1);

			player1.getDamageCounterContainer().alpha = 0;

			if (player1.exports.mugenStageName != null) {

                renderLifeBarText(player1.exports.mugenStageName,
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 80,
                              y: 18
                            });

			}            
            else {
				renderLifeBarText(handleNames(player1.getPlayerConfig().character.contentId),
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 80,
                              y: 18
                            });
			}

			player1Token = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "hudToken",
							x:44,
							y:30,
						}));
			player1Token.playFrame(1);
			player1Token.pause();
			camera.getForegroundContainer().addChild(player1Token.getViewRootContainer());

            if (player1.hasAnimation("tokenHUD")) {
                player1TokenHud = match.createVfx(new VfxStats({
							spriteContent: player1.getResource().getContent(player1.getPlayerConfig().character.contentId),
							animation: "tokenHUD",
						}));

                if (player1.getCostumeShader() != null) {
			    player1TokenHud.addShader(player1.getCostumeShader());
                }
			    player1TokenHud.pause();
			    player1Token.getViewRootContainer().addChild(player1TokenHud.getViewRootContainer());
            } else {

                player1TokenHud = match.createVfx(new VfxStats({
							spriteContent: player1.getResource().getContent("menu"),
							animation: "hud",
						}));

                if (player1.getCostumeShader() != null) {
			    player1TokenHud.addShader(player1.getCostumeShader());
                }
			    player1TokenHud.pause();
			    player1Token.getViewRootContainer().addChild(player1TokenHud.getViewRootContainer());

            }


			var sprite = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			sprite.currentAnimation = "hudMask";
			sprite.currentFrame = 1;
			var mask_filter = new MaskFilter(sprite);
			player1TokenHud.getViewRootContainer().addChild(sprite);
			player1TokenHud.getViewRootContainer().addFilter(mask_filter);

			player1LifeBar = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player1LifeBar.currentAnimation = "lifeBar";
			player1LifeBar.currentFrame = 201;
			player1LifeBar.x = 126;
			player1LifeBar.y = -6;
			player1LifeBar.scaleX = 0.425;
			player1LifeBar.scaleY = 0.425;
			player1Token.getViewRootContainer().addChild(player1LifeBar);

			player1.addEventListener(GameObjectEvent.DAMAGE_UPDATED, p1LifeBarUpdate, {persistent:true});

			player1Meter = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player1Meter.currentAnimation = "meter";
			player1Meter.currentFrame = 1;
			player1Meter.x = 164.5;
			player1Meter.y = 4.5;
			player1Meter.scaleX = 0.425;
			player1Meter.scaleY = 0.425;
			player1Token.getViewRootContainer().addChild(player1Meter);

			player1FirstWin = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player1FirstWin.currentAnimation = "wins";
			player1FirstWin.currentFrame = 1;
			player1FirstWin.x = 216.5;
			player1FirstWin.y = -17.5;
			player1FirstWin.scaleX = 0.425;
			player1FirstWin.scaleY = 0.425;
			player1Token.getViewRootContainer().addChild(player1FirstWin);

			player1SecondWin = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player1SecondWin.currentAnimation = "wins";
			player1SecondWin.currentFrame = 1;
			player1SecondWin.x = 206.5;
			player1SecondWin.y = -17.5;
			player1SecondWin.scaleX = 0.425;
			player1SecondWin.scaleY = 0.425;
			player1Token.getViewRootContainer().addChild(player1SecondWin);

            player1SideComboVisuals = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player1SideComboVisuals.currentAnimation = "combo";
            player1SideComboVisuals.currentFrame = 1;
			player1SideComboVisuals.x = 40;
			player1SideComboVisuals.y = 40;
			player1SideComboVisuals.scaleX = 0.425;
			player1SideComboVisuals.scaleY = 0.425;
            player1SideComboVisuals.alpha = 0;
			player1Token.getViewRootContainer().addChild(player1SideComboVisuals);

            //squeakyCleanFloor(player1);

            player1.addEventListener(GameObjectEvent.ENTER_HITSTUN, function(e:GameObjectEvent){
                p2SideCombo += 1;

                if (p2SideCombo >= 1) {
                    player2SideComboVisuals.alpha = 1;
                    player2SideComboVisuals.currentFrame = p2SideCombo;
                }

            }, {persistent:true});
            player1.addEventListener(GameObjectEvent.EXIT_HITSTUN, function(e:GameObjectEvent){
                
                if (player1.getState() == CState.HELD) {
                    return;
                } else {
                    player2SideComboVisuals.alpha = 0;
                    player2SideComboVisuals.currentFrame = 1;

                    p2SideCombo = 0;
                }

            }, {persistent:true});

			player1.addTimer(5,-1,function(){
				p1MeterUpdate();
                checkIfOutOfBounds(player1);
			}, {persistent:true});

                player1.addTimer(1,-1,function(){   
                    if(player1.isOnFloor()) {
                        player1.toState(CState.UNINITIALIZED, "crash_loop");
                    } else {
                        player1.toState(CState.TUMBLE);
                    }
                    
                    player1.updateAnimationStats({bodyStatus:BodyStatus.INTANGIBLE});

                }, {persistent:true, condition:function(){if (teams_isPlayer1KOd == true){return true;}}});

                player1.addTimer(95,-1,function(){   
                    player1.toState(CState.CRASH_GET_UP, "crash_get_up");
                    player1.updateAnimationStats({bodyStatus:BodyStatus.NONE});
                    player1.applyGlobalBodyStatus(BodyStatus.INVINCIBLE, 60);

                    player3.toState(CState.CRASH_GET_UP, "crash_get_up");
                    player3.updateAnimationStats({bodyStatus:BodyStatus.NONE});
                    player3.applyGlobalBodyStatus(BodyStatus.INVINCIBLE, 60);

                    teams_isPlayer1KOd = false;
                    teams_isPlayer3KOd = false;

                    switch (player2FirstWin.currentFrame) {
                                case 1:
                                    player2FirstWin.currentFrame = Random.getInt(2,7);
                                    p2Wins += 1;
                                default: 
                                    player2SecondWin.currentFrame = Random.getInt(2,7);
                                    p2Wins += 1;
                    }


            }, {persistent:true, condition:function(){if (teams_isPlayer1KOd == true && teams_isPlayer3KOd == true && player3.isOnFloor() && player1.isOnFloor()){return true;}}});


		}

		if (player1 != char && player2 == null && playerNegative1 != char && playerNegative2 != char) {
			
			player2 = char;
            players.push(player2);
			player2.getDamageCounterContainer().alpha = 0;

			if (player2.exports.mugenStageName != null) {

			var sexyString:string = reverseString(player2.exports.mugenStageName);

			renderEvilLifeBarText(sexyString,
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 556,
                              y: 18
                            });

			} 
            
            else {

				var sexyBaseCastString:string = reverseString(handleNames(player2.getPlayerConfig().character.contentId));

				renderEvilLifeBarText(sexyBaseCastString,
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 556,
                              y: 18
                            });
			}

			player2Token = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "hudToken",
							x:594,
							y:30,
						}));
			player2Token.playFrame(1);
			player2Token.pause();
			camera.getForegroundContainer().addChild(player2Token.getViewRootContainer());

            
			if (player2.hasAnimation("tokenHUD")) {
                player2TokenHud = match.createVfx(new VfxStats({
							spriteContent: player2.getResource().getContent(player2.getPlayerConfig().character.contentId),
							animation: "tokenHUD",
						}));

                if (player2.getCostumeShader() != null) {
			    player2TokenHud.addShader(player2.getCostumeShader());
                }
			    player2TokenHud.pause();
			    player2Token.getViewRootContainer().addChild(player2TokenHud.getViewRootContainer());
            } else {

                player2TokenHud = match.createVfx(new VfxStats({
							spriteContent: player2.getResource().getContent("menu"),
							animation: "hud",
						}));

                if (player2.getCostumeShader() != null) {
			    player2TokenHud.addShader(player2.getCostumeShader());
                }
			    player2TokenHud.pause();
			    player2Token.getViewRootContainer().addChild(player2TokenHud.getViewRootContainer());

            }

			var sprite = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			sprite.currentAnimation = "hudMask";
			sprite.currentFrame = 1;
			var mask_filter = new MaskFilter(sprite);
			player2TokenHud.getViewRootContainer().addChild(sprite);
			player2TokenHud.getViewRootContainer().addFilter(mask_filter);

			player2LifeBar = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player2LifeBar.currentAnimation = "p2lifeBar";
			player2LifeBar.currentFrame = 201;
			player2LifeBar.x = -126;
			player2LifeBar.y = -6;
			player2LifeBar.scaleX = 0.425;
			player2LifeBar.scaleY = 0.425;
			player2Token.getViewRootContainer().addChild(player2LifeBar);

			player2.addEventListener(GameObjectEvent.DAMAGE_UPDATED, p2LifeBarUpdate, {persistent:true});

			player2Meter = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player2Meter.currentAnimation = "p2meter";
			player2Meter.currentFrame = 1;
			player2Meter.x = -164.5;
			player2Meter.y = 4.5;
			player2Meter.scaleX = 0.425;
			player2Meter.scaleY = 0.425;
			player2Token.getViewRootContainer().addChild(player2Meter);

            player2FirstWin = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player2FirstWin.currentAnimation = "wins";
			player2FirstWin.currentFrame = 1;
			player2FirstWin.scaleX = -1;
			player2FirstWin.x = -216.5;
			player2FirstWin.y = -17.5;
			player2FirstWin.scaleX = 0.425;
			player2FirstWin.scaleY = 0.425;
			player2Token.getViewRootContainer().addChild(player2FirstWin);

            player2SecondWin = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player2SecondWin.currentAnimation = "wins";
			player2SecondWin.currentFrame = 1;
			player2SecondWin.scaleX = -1;
			player2SecondWin.x = -206.5;
			player2SecondWin.y = -17.5;
			player2SecondWin.scaleX = 0.425;
			player2SecondWin.scaleY = 0.425;
			player2Token.getViewRootContainer().addChild(player2SecondWin);

            player2SideComboVisuals = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player2SideComboVisuals.currentAnimation = "p2combo";
            player2SideComboVisuals.currentFrame = 1;
			player2SideComboVisuals.x = -15;
			player2SideComboVisuals.y = 40;
			player2SideComboVisuals.scaleX = 0.425;
			player2SideComboVisuals.scaleY = 0.425;
            player2SideComboVisuals.alpha = 0;
			player2Token.getViewRootContainer().addChild(player2SideComboVisuals);

            player4SideComboVisuals = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player4SideComboVisuals.currentAnimation = "p2combo";
            player4SideComboVisuals.currentFrame = 1;
			player4SideComboVisuals.x = -15;
			player4SideComboVisuals.y = 60;
			player4SideComboVisuals.scaleX = 0.425;
			player4SideComboVisuals.scaleY = 0.425;
            player4SideComboVisuals.alpha = 0;
			player2Token.getViewRootContainer().addChild(player4SideComboVisuals);

            player2.addEventListener(GameObjectEvent.ENTER_HITSTUN, function(e:GameObjectEvent){
                p1SideCombo += 1;

                if (p1SideCombo >= 1) {
                    player1SideComboVisuals.alpha = 1;
                    player1SideComboVisuals.currentFrame = p1SideCombo;
                }

            }, {persistent:true});
            player2.addEventListener(GameObjectEvent.EXIT_HITSTUN, function(e:GameObjectEvent){

                if (player2.getState() == CState.HELD) {
                    return;
                } else {
                    player1SideComboVisuals.alpha = 0;
                    player1SideComboVisuals.currentFrame = 1;

                    p1SideCombo = 0;
                }

            }, {persistent:true});

			player2.addTimer(5,-1,function(){
				p2MeterUpdate();
                checkIfOutOfBounds(player2);
			}, {persistent:true});

                player2.addTimer(1,-1,function(){   
                    if(player2.isOnFloor()) {
                        player2.toState(CState.UNINITIALIZED, "crash_loop");
                    } else {
                        player2.toState(CState.TUMBLE);
                    }
                    
                    player2.updateAnimationStats({bodyStatus:BodyStatus.INTANGIBLE});

                }, {persistent:true, condition:function(){if (teams_isPlayer2KOd == true){return true;}}});

                player2.addTimer(95,-1,function(){   
                    player2.toState(CState.CRASH_GET_UP, "crash_get_up");
                    player2.updateAnimationStats({bodyStatus:BodyStatus.NONE});
                    player2.applyGlobalBodyStatus(BodyStatus.INVINCIBLE, 60);

                    player4.toState(CState.CRASH_GET_UP, "crash_get_up");
                    player4.updateAnimationStats({bodyStatus:BodyStatus.NONE});
                    player4.applyGlobalBodyStatus(BodyStatus.INVINCIBLE, 60);

                    teams_isPlayer2KOd = false;
                    teams_isPlayer4KOd = false;

                    switch (player1FirstWin.currentFrame) {
                    case 1:
                        player1FirstWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                    default: 
                        player1SecondWin.currentFrame = Random.getInt(2,7);
                        p1Wins += 1;
                }
            }, {persistent:true, condition:function(){if (teams_isPlayer2KOd == true && teams_isPlayer4KOd == true && player2.isOnFloor() && player4.isOnFloor()){return true;}}});


		}

        if (player1 != char && player2 != char && player3 == null && playerNegative1 != char && playerNegative2 != char) {

            player3 = char;
            players.push(player3);
            player3.getDamageCounterContainer().alpha = 0;

            player1.getPlayerConfig().team = 0;
            player3.getPlayerConfig().team = 0;

            player2.getPlayerConfig().team = 2;

            if (player3.exports.mugenStageName != null) {

			renderSmallLifeBarText(player3.exports.mugenStageName,
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 97.5,
                              y: 40.5
                            });

			} 
            
            else {
				renderSmallLifeBarText(handleNames(player3.getPlayerConfig().character.contentId),
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 97.5,
                              y: 40.5
                            });
			}

            player3Token = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "hudToken",
							x:84,
							y:43.5,
						}));
			player3Token.playFrame(1);
            player3Token.setScaleX(0.425);
            player3Token.setScaleY(0.425);
			player3Token.pause();
			camera.getForegroundContainer().addChild(player3Token.getViewRootContainer());


			if (player3.hasAnimation("tokenHUDmini")) {
                player3TokenHud = match.createVfx(new VfxStats({
							spriteContent: player3.getResource().getContent(player3.getPlayerConfig().character.contentId),
							animation: "tokenHUDmini",
						}));

                if (player3.getCostumeShader() != null) {
			    player3TokenHud.addShader(player3.getCostumeShader());
                }
			    player3TokenHud.pause();
			    player3Token.getViewRootContainer().addChild(player3TokenHud.getViewRootContainer());
            } else {

                player3TokenHud = match.createVfx(new VfxStats({
							spriteContent: player3.getResource().getContent("menu"),
							animation: "hud",
						}));

                if (player3.getCostumeShader() != null) {
			    player3TokenHud.addShader(player3.getCostumeShader());
                }
			    player3TokenHud.pause();
                player3TokenHud.setScaleX(0.425);
                player3TokenHud.setScaleY(0.425);
			    player3Token.getViewRootContainer().addChild(player3TokenHud.getViewRootContainer());

            }

			var sprite = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			sprite.currentAnimation = "hudMask";
            sprite.scaleX = 0.425;
            sprite.scaleY = 0.425;
			sprite.currentFrame = 1;
			var mask_filter = new MaskFilter(sprite);
			player3TokenHud.getViewRootContainer().addChild(sprite);
			player3TokenHud.getViewRootContainer().addFilter(mask_filter);

            player1Token.getViewRootContainer().removeChild(player1LifeBar);
            player1.removeEventListener(GameObjectEvent.DAMAGE_UPDATED, p1LifeBarUpdate);

            team1LifeBarContainerSprite = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			team1LifeBarContainerSprite.currentAnimation = "lifeBarEmpty";
			team1LifeBarContainerSprite.currentFrame = 201;
			team1LifeBarContainerSprite.x = 126;
			team1LifeBarContainerSprite.y = -6;
			team1LifeBarContainerSprite.scaleX = 0.425;
			team1LifeBarContainerSprite.scaleY = 0.425;
			player1Token.getViewRootContainer().addChild(team1LifeBarContainerSprite);

            team1Player1LifeBar = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			team1Player1LifeBar.currentAnimation = "lifeBarTeams";
			team1Player1LifeBar.currentFrame = 201;
			team1Player1LifeBar.x = 128;
			team1Player1LifeBar.y = -8;
			team1Player1LifeBar.scaleX = 0.425;
			team1Player1LifeBar.scaleY = 0.425;
			player1Token.getViewRootContainer().addChild(team1Player1LifeBar);

            player1.addEventListener(GameObjectEvent.DAMAGE_UPDATED, p1TeamLifeBarUpdate, {persistent:true});

            team1Player3LifeBar = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			team1Player3LifeBar.currentAnimation = "lifeBarTeams";
			team1Player3LifeBar.currentFrame = 201;
			team1Player3LifeBar.x = 128;
			team1Player3LifeBar.y = -4;
			team1Player3LifeBar.scaleX = 0.425;
			team1Player3LifeBar.scaleY = 0.425;
			player1Token.getViewRootContainer().addChild(team1Player3LifeBar);

            player3.addEventListener(GameObjectEvent.DAMAGE_UPDATED, p3TeamLifeBarUpdate, {persistent:true});

            player3Meter = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player3Meter.currentAnimation = "p3meter";
			player3Meter.currentFrame = 201;
			player3Meter.x = 96.5;
			player3Meter.y = 0;
			player3Meter.scaleX = 0.2125;
			player3Meter.scaleY = 0.2125;
			player3Token.getViewRootContainer().addChild(player3Meter);

            player3SideComboVisuals = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player3SideComboVisuals.currentAnimation = "combo";
            player3SideComboVisuals.currentFrame = 1;
			player3SideComboVisuals.x = 40;
			player3SideComboVisuals.y = 60;
			player3SideComboVisuals.scaleX = 0.425;
			player3SideComboVisuals.scaleY = 0.425;
            player3SideComboVisuals.alpha = 0;
			player1Token.getViewRootContainer().addChild(player3SideComboVisuals);

            player3.addEventListener(GameObjectEvent.ENTER_HITSTUN, function(e:GameObjectEvent){
                p4SideCombo += 1;

                if (p4SideCombo >= 1) {
                    player4SideComboVisuals.alpha = 1;
                    player4SideComboVisuals.currentFrame = p4SideCombo;
                }

            }, {persistent:true});
            player3.addEventListener(GameObjectEvent.EXIT_HITSTUN, function(e:GameObjectEvent){

                if (player3.getState() == CState.HELD) {
                    return;
                } else {
                    player4SideComboVisuals.alpha = 0;
                    player1SideComboVisuals.currentFrame = 1;

                    p4SideCombo = 0;
                }

            }, {persistent:true});

            player3.addTimer(5,-1,function(){
                p3MeterUpdate();
                checkIfOutOfBounds(player3);
			}, {persistent:true});

            if (players.length >-3) {
                player3.addTimer(1,-1,function(){   
                    if (player3.isOnFloor()){
                        player3.toState(CState.UNINITIALIZED, "crash_loop");
                    } else {
                    player3.toState(CState.TUMBLE);
                    }
                    player3.updateAnimationStats({bodyStatus:BodyStatus.INTANGIBLE});

                }, {persistent:true, condition:function(){if (teams_isPlayer3KOd == true){return true;}}});
            }


        }

        if (player1 != char && player2 != char && player3 != char && player4 == null && playerNegative1 != char && playerNegative2 != char) {

            player4 = char;
            players.push(player4);
            player4.getDamageCounterContainer().alpha = 0;

            player4.getPlayerConfig().team = 2;

            if (player4.exports.mugenStageName != null) {

            var evilString:string = reverseString(player4.exports.mugenStageName);

			renderSmallEvilLifeBarText(evilString,
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 539.5,
                              y: 40.5
                            });

			} 
            
            else {

                var evilBaseCastString:string = reverseString(handleNames(player4.getPlayerConfig().character.contentId));

				renderSmallEvilLifeBarText(evilBaseCastString,
                            textSprites, camera.getForegroundContainer(),
                            {
                              x: 539.5,
                              y: 40.5
                            });
			}

            player4Token = match.createVfx(new VfxStats({
							spriteContent: self.getResource().getContent("mountainsidetemple"),
							animation: "hudToken",
							x:554,
							y:43.5,
						}));
			player4Token.playFrame(1);
            player4Token.setScaleX(-0.425);
            player4Token.setScaleY(0.425);
			player4Token.pause();
			camera.getForegroundContainer().addChild(player4Token.getViewRootContainer());


			if (player4.hasAnimation("tokenHUDmini")) {
                player4TokenHud = match.createVfx(new VfxStats({
							spriteContent: player4.getResource().getContent(player4.getPlayerConfig().character.contentId),
							animation: "tokenHUDmini",
						}));

                if (player4.getCostumeShader() != null) {
			    player4TokenHud.addShader(player4.getCostumeShader());
                }
			    player4TokenHud.pause();
			    player4Token.getViewRootContainer().addChild(player4TokenHud.getViewRootContainer());
            } else {

                player4TokenHud = match.createVfx(new VfxStats({
							spriteContent: player4.getResource().getContent("menu"),
							animation: "hud",
						}));

                if (player4.getCostumeShader() != null) {
			    player4TokenHud.addShader(player4.getCostumeShader());
                }
			    player4TokenHud.pause();
                player4TokenHud.setScaleX(0.425);
                player4TokenHud.setScaleY(0.425);
			    player4Token.getViewRootContainer().addChild(player4TokenHud.getViewRootContainer());

            }

			var sprite = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			sprite.currentAnimation = "hudMask";
            sprite.scaleX = 0.425;
            sprite.scaleY = 0.425;
			sprite.currentFrame = 1;
			var mask_filter = new MaskFilter(sprite);
			player4TokenHud.getViewRootContainer().addChild(sprite);
			player4TokenHud.getViewRootContainer().addFilter(mask_filter);

            player2Token.getViewRootContainer().removeChild(player2LifeBar);
            player2.removeEventListener(GameObjectEvent.DAMAGE_UPDATED, p2LifeBarUpdate);

            team2LifeBarContainerSprite = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			team2LifeBarContainerSprite.currentAnimation = "lifeBarEmpty";
			team2LifeBarContainerSprite.currentFrame = 201;
			team2LifeBarContainerSprite.x = -126;
			team2LifeBarContainerSprite.y = -6;
			team2LifeBarContainerSprite.scaleX = -0.425;
			team2LifeBarContainerSprite.scaleY = 0.425;
			player2Token.getViewRootContainer().addChild(team2LifeBarContainerSprite);

            team2Player2LifeBar = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			team2Player2LifeBar.currentAnimation = "lifeBarTeams";
			team2Player2LifeBar.currentFrame = 201;
			team2Player2LifeBar.x = -128;
			team2Player2LifeBar.y = -8;
			team2Player2LifeBar.scaleX = -0.425;
			team2Player2LifeBar.scaleY = 0.425;
			player2Token.getViewRootContainer().addChild(team2Player2LifeBar);

            player2.addEventListener(GameObjectEvent.DAMAGE_UPDATED, p2TeamLifeBarUpdate, {persistent:true});

            team2Player4LifeBar = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			team2Player4LifeBar.currentAnimation = "lifeBarTeams";
			team2Player4LifeBar.currentFrame = 201;
			team2Player4LifeBar.x = -128;
			team2Player4LifeBar.y = -4;
			team2Player4LifeBar.scaleX = -0.425;
			team2Player4LifeBar.scaleY = 0.425;
			player2Token.getViewRootContainer().addChild(team2Player4LifeBar);

            player4.addEventListener(GameObjectEvent.DAMAGE_UPDATED, p4TeamLifeBarUpdate, {persistent:true});

            player4Meter = Sprite.create(self.getResource().getContent("mountainsidetemple"));   
			player4Meter.currentAnimation = "p4meter";
			player4Meter.currentFrame = 201;
			player4Meter.x = -96.5;
			player4Meter.y = 0;
			player4Meter.scaleX = 0.2125;
			player4Meter.scaleY = 0.2125;
			player4Token.getViewRootContainer().addChild(player4Meter);

            player4.addEventListener(GameObjectEvent.ENTER_HITSTUN, function(e:GameObjectEvent){
                p3SideCombo += 1;

                if (p3SideCombo >= 1) {
                    player3SideComboVisuals.alpha = 1;
                    player3SideComboVisuals.currentFrame = p3SideCombo;
                }

            }, {persistent:true});
            player4.addEventListener(GameObjectEvent.EXIT_HITSTUN, function(e:GameObjectEvent){

                if (player4.getState() == CState.HELD) {
                    return;
                } else {
                    player3SideComboVisuals.alpha = 0;
                    player3SideComboVisuals.currentFrame = 1;

                    p3SideCombo = 0;
                }

            }, {persistent:true});

            player4.addTimer(5,-1,function(){
                p4MeterUpdate();
                checkIfOutOfBounds(player4);
			}, {persistent:true});

            if (players.length == 4) { //shocker i know
                player4.addTimer(1,-1,function(){   
                    if (player4.isOnFloor()){
                        player4.toState(CState.UNINITIALIZED, "crash_loop");
                    } else {
                    player4.toState(CState.TUMBLE);
                    }
                    player4.updateAnimationStats({bodyStatus:BodyStatus.INTANGIBLE});

                }, {persistent:true, condition:function(){if (teams_isPlayer4KOd == true){return true;}}});
            }


        }

			moveCooldown.set(char.addStatusEffect(StatusEffectType.ATTACK_HITSTUN_MULTIPLIER, 1.2));
			moveCooldown.set(char.addStatusEffect(StatusEffectType.ATTACK_SELF_HITSTOP_MULTIPLIER, 1.4));
			moveCooldown.set(char.addStatusEffect(StatusEffectType.ATTACK_HITSTOP_MULTIPLIER, 1.4));
			moveCooldown.set(char.addStatusEffect(StatusEffectType.HITBOX_DAMAGE_MULTIPLIER, 1));
			moveCooldown.set(char.addStatusEffect(StatusEffectType.ATTACK_KNOCKBACK_MULTIPLIER, 1));
			moveCooldown.set(char.addStatusEffect(StatusEffectType.FAST_FALL_SPEED_MULTIPLIER, 2));

			char.addEventListener(GameObjectEvent.HITBOX_CONNECTED, turbo, {persistent:true});
			char.addEventListener(GameObjectEvent.HIT_RECEIVED, stamina, {persistent:true});
			char.addEventListener(GameObjectEvent.HITBOX_CONNECTED, evilAssCooldownAdder, {persistent:true});
            char.addEventListener(GameObjectEvent.HITBOX_CONNECTED, hitSoundReplacement, {persistent:true});
            char.addEventListener(GameObjectEvent.HITBOX_CONNECTED, hitstopDecay, {persistent:true});  

            if (idMatchesInNoFlyList(char.getPlayerConfig().character.contentId)){
                char.removeEventListener(GameObjectEvent.HITBOX_CONNECTED, turbo);
                char.removeEventListener(GameObjectEvent.HITBOX_CONNECTED, evilAssCooldownAdder);
            }

            char.addEventListener(EntityEvent.STATE_CHANGE, function(e:EntityEvent){
                if (e.data.fromState == CState.INTRO && e.data.toState == CState.STAND) {
                    switch(idMatchesInNoFlyList(char.getPlayerConfig().character.contentId)) {
                        case true:
                            return;
                        case false:
                            char.toState(CState.UNINITIALIZED, "stand");
                    }
            }
            
            }, {persistent:true});

            
            char.addTimer(100, 1, function(){
            char.toState(CState.STAND);
            }, {persistent:true});

			char.addTimer(1,-1,function(){
				char.updateHitboxStats(0, {knockbackCap:80});
			}, {persistent:true});

            roundLogic();
		}
	}

	
}

function disableMoveCancel(characterAffected:Character, amountOfFrames:Int) {
    characterAffected.removeEventListener(GameObjectEvent.HITBOX_CONNECTED, turbo);
    characterAffected.removeEventListener(GameObjectEvent.HITBOX_CONNECTED, evilAssCooldownAdder);

    characterAffected.addTimer(amountOfFrames, 1, function(){
        characterAffected.addEventListener(GameObjectEvent.HITBOX_CONNECTED, turbo, {persistent:true});
        characterAffected.addEventListener(GameObjectEvent.HITBOX_CONNECTED, evilAssCooldownAdder, {persistent:true});
    }, {persistent:true, pauseCondition: function() { if ( characterAffected.getHitstop() > 0 ){ return true; }}});
}

function exterminateEarlyAccessUpdateZeroPointSevenPointSevenNewAssistCadenceFromCryptOfTheNecrodancerExclamationPoint(){
    for (plr in players) {
        if (plr.getVisible() != true){
            self.addTimer(1,10,function(){
                plr.setVisible(true);
            }, {persistent:true});
        }
    }
}

function hitstopDecay(e:GameObjectEvent) {
    if (e.data.hitboxStats.hitstop >= 30){
        e.data.hitboxStats.hitstop = 18.75 + (0.375*e.data.hitboxStats.hitstop);
    }
}

function hitSoundReplacement(e:GameObjectEvent){
    var hitSound = damageCheck(e.data.hitboxStats.damage);


    if (e.data.hitboxStats.hitSoundOverride != "#n/a" && e.data.hitboxStats.hitSoundOverride == null /*please dont ask*/ ) {
				e.data.hitboxStats.hitSoundOverride = self.getResource().getContent(hitSound);
    }
}

function damageCheck(damage:number){
    
        if (damage < 5) {
            return "light";
        } else if (damage >= 5 && damage < 10) {
            return "medium";
        } else if (damage >= 10) {
            return "heavy";  
        }
}

function onTeardown(){
}
function onKill(){
}
function onStale(){
}
function afterPushState(){
}
function afterPopState(){
}
function afterFlushStates(){
}

