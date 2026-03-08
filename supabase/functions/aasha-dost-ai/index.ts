// =====================================================================
// AASHA MEDIX — Supabase Edge Function: aasha-dost-ai
//
// Location: supabase/functions/aasha-dost-ai/index.ts
// Deploy:   supabase functions deploy aasha-dost-ai
//
// This is the Phase 3 PLACEHOLDER. It accepts a POST request
// with a { "message": "..." } body and returns a structured
// placeholder response.
//
// PHASE 5 TODO: Replace the placeholder logic with a real call
// to an AI provider (OpenAI / Google Gemini) using the
// AI_API_KEY secret set in the Supabase project dashboard.
//
// Set the secret:
//   supabase secrets set AI_API_KEY=your_key_here
//
// =====================================================================
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req: Request) => {
    // Handle CORS preflight
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders });
    }

    try {
        // Verify the request method
        if (req.method !== 'POST') {
            return new Response(
                JSON.stringify({ error: 'Method not allowed. Use POST.' }),
                { status: 405, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
            );
        }

        // Parse request body
        const body = await req.json().catch(() => null);
        if (!body || typeof body.message !== 'string' || body.message.trim() === '') {
            return new Response(
                JSON.stringify({ error: 'Invalid request. Body must contain a non-empty "message" string.' }),
                { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
            );
        }

        const userMessage: string = body.message.trim();

        // ----------------------------------------------------------------
        // PHASE 5: Replace the block below with a real AI API call.
        //
        // Example using OpenAI:
        // const aiResponse = await fetch('https://api.openai.com/v1/chat/completions', {
        //   method: 'POST',
        //   headers: {
        //     'Authorization': `Bearer ${Deno.env.get('AI_API_KEY')}`,
        //     'Content-Type': 'application/json',
        //   },
        //   body: JSON.stringify({
        //     model: 'gpt-4o-mini',
        //     messages: [
        //       { role: 'system', content: 'You are AASHA DOST, a helpful AI health assistant for the AASHA MEDIX platform in India. Provide accurate, helpful, and empathetic healthcare guidance.' },
        //       { role: 'user', content: userMessage }
        //     ],
        //     max_tokens: 500,
        //   }),
        // });
        // const aiData = await aiResponse.json();
        // const reply = aiData.choices[0].message.content;
        // ----------------------------------------------------------------

        // PLACEHOLDER response until Phase 5 is implemented
        const placeholderReply = `[AASHA DOST AI — Phase 5 Pending] Received: "${userMessage}". The AI backend is not yet connected. Please implement the Edge Function with your chosen AI provider (OpenAI/Gemini) and set the AI_API_KEY secret.`;

        return new Response(
            JSON.stringify({
                reply: placeholderReply,
                status: 'placeholder',
                phase: 'Phase 3 — AI integration pending (Phase 5)',
                timestamp: new Date().toISOString(),
            }),
            {
                status: 200,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            }
        );

    } catch (error) {
        console.error('[aasha-dost-ai] Unhandled error:', error);
        return new Response(
            JSON.stringify({ error: 'Internal server error', details: String(error) }),
            { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        );
    }
});
