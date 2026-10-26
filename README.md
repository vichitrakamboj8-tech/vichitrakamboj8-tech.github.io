# AI Codex Masterclass

A responsive React / Next.js App Router application, hosted with the Sites Vinext compatibility runtime. Uses Tailwind CSS, Framer Motion, Lucide, and locally generated UPI QR codes. Direct UPI with manual verification is the primary payment method, following the final payment requirements.

## Current state

The site starts in explicit demonstration mode. No real payments are collected, QR/deep-link payment is disabled, and demo UTR submissions never create a confirmed booking. No database or email credentials have been supplied. The published Site is owner-private by default.

## Activate enrollment

1. Create a Supabase project and execute `db/masterclass.sql`. Tables have RLS enabled, no public client policies, and all access goes through server API routes. The service-role key must never enter browser code.
2. Set runtime secrets through Sites: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `ADMIN_EMAIL`, `RESEND_API_KEY`, `EMAIL_FROM`, `SITE_URL`, and `GOOGLE_MEET_URL`. See `.env.example` for names only. Verify your sending domain with Resend. Use the organizer's actual ChatGPT account email for ADMIN_EMAIL.
3. Visit `/admin`, sign in with the organizer account, and configure date, time, capacity, language, instructor, contact address, and policies. All session times use Asia/Kolkata / IST. The actual Meet URL stays in the server-only GOOGLE_MEET_URL secret.
4. Test registration, UPI handoff, unique references, independently verified approval, confirmation email, and private student access using a controlled registration. Set `PAYMENTS_ENABLED=true` only when ready to accept real payments. Deploy the saved version after updating secrets. Public availability requires an explicit access change by the owner.
5. Do not approve a payment without checking your bank/UPI history. A UTR submission is pending, never confirmation. Capacity is checked atomically during approval. When capacity fills after a student has paid, resolve that payment with the student before changing capacity or refunding; unverified registrations do not reserve inventory.

## Operations

- `/admin`: registration filters, approve/reject, retry confirmation email, CSV export for Excel, and editable session configuration.
- Confirmation and receipt email is sent only after approval. A failed email remains retryable; approval remains recorded. Resend idempotency prevents repeated delivery on retries within its idempotency window.
- Students receive a cryptographically random private token; only its SHA-256 hash is stored. Save the token when registering. It authorizes access to one attendee record. Treat it as a password; support recovery is an organizer task after identity verification.
- The private joining link is returned only for confirmed students from 15 minutes before the session until two hours after the scheduled start. Calendar export also requires confirmed status and includes no private Meet URL.
- Countdown is hidden unless a real deadline is configured. No invented seat counts, testimonials, instructor credentials, recording, certificate, or refund promises.
- Fixed ₹9 UPI amount, exact payee ID `vichitrakamboj8@oksbi.com`, and payee name Vichitra Kamboj. Pricing cannot be changed independently of the UPI amount. Session policy text is editable.
- Only direct UPI is enabled. Razorpay credentials were not supplied; no fake Razorpay integration or payment verification is represented.

## Development

Node 22.13+ required. Install using the Sites dependency helper, then `npm run dev`. Build using the Sites build helper. Server API calls use HTTP and run on Cloudflare Workers. Secrets are read from Worker bindings, with process.env fallback for development. Preserve the Sites Vite integration.

## Before public launch

Finalize policy and contact text, choose your schedule/capacity, connect backend services, and test a complete live registration. Database, email, bank reconciliation, and real mobile UPI payments cannot be verified without your service configuration. Do not use demo records as evidence of a payment.

Configured session: 1 November 2026, 5:00–6:00 PM India Standard Time. The joining window opens at 4:45 PM IST.
