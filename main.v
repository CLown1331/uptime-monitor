import os
import net.http
import json
import time

struct WebhookPaylod {
	content string
}

fn fail(url string, webhook_url string) ? {
	time_stamp := time.utc().str()
	http.post_json(webhook_url, json.encode(WebhookPaylod{
		content: '$url down! $time_stamp @here'
	})) ?
}

fn success(url string, webhook_url string) ? {
	http.post_json(webhook_url, json.encode(WebhookPaylod{
		content: '$url up! @here'
	})) ?
}

fn main() {
	url := os.args[1]
	expected_code := os.args[2].int()
	expected_response := os.args[3]
	webhook_url := os.args[4]
	response := http.get(url) or {
		fail(url, webhook_url) or {}
		return
	}
	println(response.text.trim(' \r\n'))
	println(response.status_code)
	if response.text.trim(' \r\n') != expected_response || response.status_code != expected_code {
		fail(url, webhook_url) or {}
		return
	}
	// success(url, webhook_url) or {}
}
