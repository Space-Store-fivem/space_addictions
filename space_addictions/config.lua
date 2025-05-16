Config = {}

Config.DrugImmunity = 100 -- quanto o jogador pode resistir aos efeitos da droga ao mesmo tempo (drugStrength)

Config.UsableDrugs = {
    ["joint"] = {
        label = "Maconha",
        animation = 'smoke', -- (smoke/syringe/sniff/pill)
        drugStrength = 50, -- esta quantidade será removida da imunidade do jogador durante a duração do efeito
        healthEffects = {
            armour = 10,
            health = -10
        },
        addiction = {
            chance = 100, -- 0-100%
            time = 2 -- tempo até o efeito acabar e precisar de outra dose (em minutos)
        },
        effect = {
            duration = 30, -- em segundos
            screenFX = "DefaultFlash",
            speedMultiplier = 1.0, -- de 1.0 a 1.49
            walkingStyle = "MOVE_M@DRUNK@SLIGHTLYDRUNK",
            cameraShakeIntensity = 1.0,
        }
    },
    ["cocaine"] = {
        label = "Cocaína",
        animation = 'sniff',
        drugStrength = 10,
        healthEffects = {
            armour = 10,
            health = -10
        },
        addiction = {
            chance = 100,
            time = 60
        },
        effect = {
            duration = 30,
            screenFX = "DefaultFlash",
            speedMultiplier = 1.0,
            walkingStyle = "MOVE_M@DRUNK@SLIGHTLYDRUNK",
            cameraShakeIntensity = 1.0,
        }
    },
    ["meth"] = {
        label = "Metanfetamina",
        animation = 'syringe',
        drugStrength = 5,
        healthEffects = {
            armour = 10,
            health = -10
        },
        addiction = {
            chance = 0,
            time = 60
        },
        effect = {
            duration = 180,
            screenFX = "DefaultFlash",
            speedMultiplier = 1.0,
            walkingStyle = "MOVE_M@DRUNK@SLIGHTLYDRUNK",
            cameraShakeIntensity = 1.0,
        }
    },
    ["mdma"] = {
        label = "MDMA",
        animation = 'pill',
        drugStrength = 5,
        healthEffects = {
            armour = 10,
            health = -10
        },
        addiction = {
            chance = 0,
            time = 60
        },
        effect = {
            duration = 180,
            screenFX = "DefaultFlash",
            speedMultiplier = 1.0,
            walkingStyle = "MOVE_M@DRUNK@SLIGHTLYDRUNK",
            cameraShakeIntensity = 1.0,
        }
    },
}

Config.Medication = {
    ["cura_maconha"] = {'marijuana'},
    ["cura_universal"] = {'marijuana', 'cocaine', 'heroin', 'mdma'}
}

Config.Translations = {
    notification_header = "Atenção",
    overdose_text = "Você está",
    overdose_highlighted_text = "Overdose",
    overdose_description = "Seu corpo não conseguiu lidar com a quantidade de substâncias ingeridas...",
    addiction_text = "Você está viciando em",
    addiction_description = "Com a substância saindo do seu corpo, você começará a se sentir mal. É necessário um tratamento adequado para se livrar da dependência.",
}
