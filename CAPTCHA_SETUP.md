# CAPTCHA setup for the TasteTrip launch page

Cloudflare Turnstile can protect the public waitlist form from automated spam without showing most visitors a puzzle.

## Required setup

1. Create a Turnstile widget for the launch page's final Netlify domain.
2. Keep the Turnstile **secret key** only in Netlify environment variables.
3. The public Turnstile **site key** may appear in the launch-page HTML.
4. Submit the Turnstile response to a Netlify Function.
5. The function must verify the response with Cloudflare before inserting the email into `beta_signups`.

Do not enable the widget in production until both the site key and server-side verification function are configured. A client-only CAPTCHA check can be bypassed and does not protect the database.
