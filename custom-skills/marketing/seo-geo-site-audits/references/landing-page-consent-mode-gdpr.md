# Landing page Consent Mode / GDPR pattern

Use this reference when fixing cookie/GDPR findings on a marketing landing page that uses Google Tag Manager and Meta Pixel.

## Goal

Balance GDPR-safe default behavior with useful conversion tracking after consent:

- Before consent: no Meta Pixel PageView, no Meta marketing events, no Google ad/analytics storage.
- GTM may load before consent only when Google Consent Mode v2 is set to default denied before the GTM snippet and GTM tags respect consent settings.
- After consent: grant Google consent, load Meta Pixel, send PageView, and allow conversion events.
- If the user asks for pre-consent visit counts, prefer a separate cookieless/server-side aggregate counter; do not use Meta Pixel for pre-consent PageView.

## Recommended implementation

1. Add this before the GTM snippet:

```html
<script>
    window.dataLayer = window.dataLayer || [];
    function gtag() { dataLayer.push(arguments); }

    window.hasMarketingConsent = function () {
        return localStorage.getItem('cookies_accepted') === 'true';
    };

    window.updateGoogleConsent = function (state) {
        gtag('consent', 'update', {
            'ad_storage': state,
            'analytics_storage': state,
            'ad_user_data': state,
            'ad_personalization': state
        });
    };

    gtag('consent', 'default', {
        'ad_storage': 'denied',
        'analytics_storage': 'denied',
        'ad_user_data': 'denied',
        'ad_personalization': 'denied',
        'wait_for_update': 500
    });

    if (window.hasMarketingConsent()) {
        window.updateGoogleConsent('granted');
    }
</script>
```

2. Keep GTM after the default-denied block.

3. Replace eager Meta Pixel initialization with a consent-gated loader:

```html
<script>
    window.loadMetaPixel = function () {
        if (window.metaPixelLoaded || !window.hasMarketingConsent()) return;
        !function (f, b, e, v, n, t, s) {
            if (f.fbq) return; n = f.fbq = function () {
                n.callMethod ? n.callMethod.apply(n, arguments) : n.queue.push(arguments)
            };
            if (!f._fbq) f._fbq = n; n.push = n; n.loaded = !0; n.version = '2.0';
            n.queue = []; t = b.createElement(e); t.async = !0;
            t.src = v; s = b.getElementsByTagName(e)[0];
            s.parentNode.insertBefore(t, s)
        }(window, document, 'script', 'https://connect.facebook.net/en_US/fbevents.js');
        fbq('consent', 'grant');
        fbq('init', 'PIXEL_ID_HERE');
        fbq('track', 'PageView');
        window.metaPixelLoaded = true;
    };

    window.trackMetaEvent = function (eventName, params) {
        if (window.hasMarketingConsent()) {
            window.loadMetaPixel();
            if (typeof fbq === 'function') {
                fbq('track', eventName, params || {});
            }
        }
    };

    if (window.hasMarketingConsent()) {
        window.loadMetaPixel();
    }
</script>
```

4. Remove Meta Pixel `<noscript>` tracking image when implementing strict pre-consent blocking; it can send a PageView without JavaScript consent logic.

5. On accept button:

```js
localStorage.setItem('cookies_accepted', 'true');
localStorage.removeItem('cookies_declined');
window.updateGoogleConsent('granted');
window.loadMetaPixel();
window.dataLayer = window.dataLayer || [];
window.dataLayer.push({ event: 'cookies_accepted' });
```

6. On decline button:

```js
localStorage.removeItem('cookies_accepted');
localStorage.setItem('cookies_declined', 'true');
window.updateGoogleConsent('denied');
if (typeof fbq === 'function') fbq('consent', 'revoke');
```

7. Gate conversion/contact events:

```js
if (window.hasMarketingConsent && window.hasMarketingConsent()) {
    window.trackMetaEvent('Lead');
    window.dataLayer.push({ event: 'lead', formId: form.id || 'preorder-form' });
}
```

Use the same pattern for `InitiateCheckout`, `Contact`, `contact_click`, and similar marketing events.

8. Add a persistent visible link to the cookie policy in the footer, not only inside the banner.

## Verification checklist

- Consent default denied appears before GTM.
- `ad_storage`, `analytics_storage`, `ad_user_data`, and `ad_personalization` default to `denied`.
- GTM snippet appears after the consent default block.
- Meta Pixel external script URL appears only inside a consent-gated loader.
- No Meta Pixel `<noscript>` image remains.
- Accept grants Google consent and loads Meta Pixel.
- Decline denies Google consent and revokes Meta consent if loaded.
- Lead / buy / contact events are gated behind `hasMarketingConsent()`.
- Footer contains a direct cookie-policy link.
- JSON-LD still parses and inline JavaScript passes a syntax check when tooling is available.

## Pitfalls

- Do not describe Meta Pixel pre-consent PageView as “only counting visits”: it still sends request data to Meta and is not the safe choice.
- Do not mix a separate cookieless visit counter into the consent-mode task unless the user explicitly asks for it.
- When the user references numbered audit findings, resolve the numbering from the report/source first; do not substitute your own previous numbered plan.