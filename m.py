import time
import json
import urllib.request
import urllib.parse

# ដាក់ Token របស់អ្នកនៅទីនេះ
TELEGRAM_TOKEN = "8623945913:AAFJMhq2azWjvSmr6pNRN_kMNNeSlTXae6E"
BASE_URL = f"https://api.telegram.org/bot{TELEGRAM_TOKEN}/"

print("----------------------------------------")
print("Bot កំពុងដំណើរការ... សូមចូលទៅ Telegram រួចផ្ញើសារ!")
print("----------------------------------------")

# មុខងារផ្ញើសារទៅ Telegram
def send_message(chat_id, text):
    url = BASE_URL + "sendMessage"
    data = urllib.parse.urlencode({"chat_id": chat_id, "text": text}).encode("utf-8")
    try:
        urllib.request.urlopen(url, data=data)
    except Exception as e:
        print("Error sending message:", e)

# មុខងារហៅ AI ឥតគិតថ្លៃ (DuckDuckGo AI API - មិនប្រើ Key)
def ask_ai(user_prompt):
    # កំណត់ការណែនាំឱ្យ AI ធ្វើជាអ្នកដោះស្រាយកូដ
    full_prompt = f"You are an expert AI code debugger. Fix bugs and explain clearly in Khmer language.\n\nUser Code:\n{user_prompt}"
    
    # ហៅទៅកាន់ Free AI API Service
    url = "https://text.pollinations.ai/"
    encoded_prompt = urllib.parse.quote(full_prompt)
    
    try:
        # ទាញយកចម្លើយពី AI
        req = urllib.request.Request(
            f"{url}{encoded_prompt}", 
            headers={'User-Agent': 'Mozilla/5.0'}
        )
        with urllib.request.urlopen(req, timeout=15) as response:
            return response.read().decode('utf-8')
    except Exception as e:
        print("AI Error:", e)
        return "សុំទោសផង ប្រព័ន្ធ AI ឥតគិតថ្លៃកំពុងរវល់។ សូមសាកល្បងម្ដងទៀត!"

# ដំណើរការទាញយកសារពី Telegram (Long Polling)
offset = 0
while True:
    try:
        url = BASE_URL + f"getUpdates?offset={offset}&timeout=10"
        with urllib.request.urlopen(url) as response:
            result = json.loads(response.read().decode('utf-8'))
            
            if result.get("ok") and result.get("result"):
                for update in result["result"]:
                    offset = update["update_id"] + 1
                    
                    # ពិនិត្យថាតើមានសារជាអក្សរចូលមកទេ
                    if "message" in update and "text" in update["message"]:
                        chat_id = update["message"]["chat_id"]
                        user_text = update["message"]["text"]
                        
                        print(f"ទទួលបានសារ: {user_text}")
                        
                        if user_text == "/start":
                            send_message(chat_id, "ជម្រាបសួរ! ខ្ញុំជា AI ជំនួយការដោះស្រាយកូដ។ 🤖\nសូមផ្ញើរកូដដែលមានបញ្ហាមក ខ្ញុំនឹងជួយពិនិត្យជូន!")
                        else:
                            # ប្រាប់អ្នកប្រើប្រាស់ថា AI កំពុងគិត
                            send_message(chat_id, "កំពុងគិត... 🧠⏳")
                            # សួរ AI រួចផ្ញើចម្លើយទៅវិញ
                            ai_response = ask_ai(user_text)
                            send_message(chat_id, ai_response)
                            
    except KeyboardInterrupt:
        print("\nBot ត្រូវបានបិទ។")
        break
    except Exception as e:
        print("Error in loop:", e)
        time.sleep(2)
