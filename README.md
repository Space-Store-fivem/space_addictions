
# 🚬 Space Addictions

Sistema avançado de dependência química para servidores **QBCore** com efeitos visuais, HUD, tratamentos e controle administrativo.

---

## 🧠 Funcionalidades

- Sistema de **vício por substância** com acúmulo individual.
- Efeitos visuais e animações personalizados para cada tipo de droga.
- Sistema de **imunidade e overdose**.
- Sistema de **medicamentos** para tratamento parcial ou total.
- HUD em tela com indicadores de dependência.
- Comando **admin para limpar vícios** de qualquer jogador.
- Comando para o próprio jogador se limpar (`/limparvicios`).
- Totalmente traduzido e personalizado para o servidor **Space RP**.

---

## 🛠️ Instalação

1. Extraia os arquivos do recurso na pasta `resources/[local]/space_addictions`.
2. Adicione no seu `server.cfg`:

   ```cfg
   ensure space_addictions
   ```

3. Execute o SQL contido no arquivo `sql.sql` para adicionar a coluna `addiction` na tabela `players`.

---

## ⚙️ Configuração

O arquivo `config.lua` permite personalizar:

### 📦 Drogas utilizáveis (`Config.UsableDrugs`)

Cada droga pode ser configurada com:

```lua
["nome_item"] = {
    label = "Nome Visível",
    animation = "pill/smoke/sniff/syringe",
    drugStrength = 10, -- aumenta o nível de vício
    healthEffects = {
        health = -10,
        armour = 0
    },
    addiction = {
        chance = 100, -- % de chance de ficar viciado
        time = 60 -- tempo em minutos até o efeito de abstinência
    },
    effect = {
        duration = 30, -- duração do efeito em segundos
        screenFX = "DefaultFlash",
        speedMultiplier = 1.0,
        walkingStyle = "MOVE_M@DRUNK@SLIGHTLYDRUNK",
        cameraShakeIntensity = 1.0
    }
}
```

### 💊 Medicamentos (`Config.Medication`)

Mapeie medicamentos a drogas específicas:

```lua
["item_de_cura"] = {'droga1', 'droga2'}
```

Use `"universal_cure"` para tratar todas as drogas.

### 💬 Traduções (`Config.Translations`)

Personalize os textos mostrados na UI do jogador.

---

## 🔧 Banco de Dados

A tabela `players` precisa conter a coluna:

```sql
ALTER TABLE players ADD COLUMN addiction LONGTEXT;
```

Ou utilize o arquivo `sql.sql` incluso.

---

## 🧪 Comandos Disponíveis

### ✅ Jogador

- `/limparvicios`  
  Envia uma solicitação para limpar os próprios vícios. Pode ser usado em clínicas ou locais de tratamento.

### 🔐 Admin

- `/limparvicios [id]`  
  Remove todos os vícios de outro jogador pelo ID (permissão admin).
