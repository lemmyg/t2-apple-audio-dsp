# SPDX-License-Identifier: MIT
# (C) 2023 T2 Linux Team

context.properties = {
    default.clock.rate = 48000
    default.clock.allowed-rates = [ 44100 48000 96000 ]
}

context.modules = [
    { name = libpipewire-module-filter-chain
        args = {
            node.description = "MacBook Pro T2 DSP Speakers"
            media.name       = "MacBook Pro T2 DSP Speakers"
            filter.graph = {
                nodes = [
                    { type = lv2
                      name = bass
                      plugin = "http://calf.sourceforge.net/plugins/BassEnhancer"
                      control = {
                        bypass = 0
                        level_in = 1.0
                        level_out 1.0
                        amount = 0.9
                        meter_in = 0
                        meter_out = 0
                        clip_in = 0
                        clip_out = 0
                        drive = 8.5
                        blend = -10.0
                        freq = 120
                        listen = 0
                        floor_active = 1
                        floor = 40
                      }
                    }
                    {
                        type = lv2
                        plugin = "http://lsp-plug.in/plugins/lv2/mb_compressor_stereo"
                        name = compressor
                        control = {
                            # Enable
                            mode = 1
                            bypass = 0

                            # Preamp volumes
                            g_in = 1.0
                            g_out = 1.0
                            g_dry = 0.0
                            g_wet = 1.0

                            bsel = 0
                            flt = 1
                            ife_l = 0
                            ofe_l = 0
                            ife_r = 0
                            ofe_r = 0

                            # Band 0
                            cbe_0 = 1
                            ce_0 = 1
                            al_0 = 0.501187 #-5 db
                            at_0 = 0.0
                            rrl_0 = 0.00001
                            rt_0 = 750.0
                            cr_0 = 2.0
                            kn_0 = 0.501187 #-5 db
                            mk_0 = 1.0
                            sla_0 = 10.0
                            bs_0 = 0 # Solo band 0 [boolean]: true/false
                            bm_0 = 0 # Mute band 0 [boolean]: true/false
                            
                            # Band 1
                            cbe_1 = 1
                            ce_1 = 1
                            sf_1 = 100 # Split frequency 2 [Hz]: 10.00000000..20000.00000000
                            al_1 = 0.251189 #-12 db Attack threshold 0 [G]: 0.00100000..1.00000000
                            at_1 = 0.0 # Attack time 0 [ms]: 0.00000000..2000.00000000
                            rrl_1 = 0.00001 # Release threshold 0 [G]: 0.00000000..63.09574890
                            rt_1 = 750 # Release time 0 [ms]: 0.00000000..5000.00000000
                            cr_1 = 2.0 # Ratio 0: 1.00000000..100.00000000
                            kn_1 = 0.251197 # Knee 0 [G]: 0.06310000..1.00000000
                            sla_1 = 10.0
                            mk_1 = 5.0
                            bs_1 = 0 # Solo band 1 [boolean]: true/false
                            bm_1 = 0 # Mute band 1 [boolean]: true/false

                            # Band 2
                            cbe_2 = 1
                            ce_2 = 1
                            sf_2 = 500
                            al_2 = 0.251189 #-12 db
                            at_2 = 0.0
                            rrl_2 = 0.00001
                            rt_2 = 750.0
                            cr_2 = 2.0
                            kn_2 = 0.251197 #-12 db
                            mk_2 = 4.5
                            sla_2 = 10.0
                            bs_2 = 0 # Solo band 2 [boolean]: true/false
                            bm_2 = 0 # Mute band 2 [boolean]: true/false

                            # Band 7
                            cbe_7 = 1
                            ce_7 = 1
                            sf_7 = 3000
                            al_7 = 0.251189 #-12 db
                            at_7 = 0.00001
                            rrl_7 = 750.0
                            cr_7 = 2.5
                            kn_7 = 0.251197 #-12 db
                            sla_7 = 10.0
                            mk_7 = 3.0
                            bs_7 = 0 # Solo band 7 [boolean]: true/false
                            bm_7 = 0 # Mute band 7 [boolean]: true/false

                            # Disable other bands
                            cbe_3 = 0
                            cbe_4 = 0
                            cbe_5 = 0
                            cbe_6 = 0
                            bs_0 = 0
                            bm_0 = 0
                        }
                    }
                    {
                         type   = ladspa
                         name   = limiter
                         plugin = fast_lookahead_limiter_1913
                         label  = fastLookaheadLimiter
                         control = { "Input gain (dB)" = 0 "Limit (dB)" = -1 "Release time (s)" = 0.8 }
                    }
                    # Left Tweeter
                    {
                        type = builtin
                        label = convolver
                        name = convLT
                        config = {
                            filename = [/usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_tweeters_4-44k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_tweeters_4-48k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_tweeters_4-96k.wav]
                            channel = 0
                        }
                    }

                    # Right Tweeter
                    {
                        type = builtin
                        label = convolver
                        name = convRT
                        config = {
                            filename = [/usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_tweeters_4-44k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_tweeters_4-48k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_tweeters_4-96k.wav]
                            channel = 0
                        }
                    }

                    # Left Woofer
                    {
                        type = builtin
                        label = convolver
                        name = convLW
                        config = {
                            filename = [/usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_woofers_4-44k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_woofers_4-48k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_woofers_4-96k.wav]
                            channel = 0
                        }
                    }

                    # Right Woofer
                    {
                        type = builtin
                        label = convolver
                        name = convRW
                        config = {
                            filename = [/usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_woofers_4-44k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_woofers_4-48k.wav,
                                        /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_woofers_4-96k.wav]
                            channel = 0
                            gain = 1.0
                        }
                    }

                    { type = builtin label = copy name = inputL }
                    { type = builtin label = copy name = inputR }
                    { type = builtin label = copy name = LW }
                    { type = builtin label = copy name = LW2 }
                    { type = builtin label = copy name = LT }
                    { type = builtin label = copy name = RW }
                    { type = builtin label = copy name = RW2 }
                    { type = builtin label = copy name = RT }
                ]
                
                 

                # Map the inputs to their appropriate convolvers
                links = [
                    { output = "bass:out_l" input = "compressor:in_l"}
                    { output = "bass:out_r" input = "compressor:in_r"}
                    { output = "compressor:out_l" input = "limiter:Input 1"}
                    { output = "compressor:out_r" input = "limiter:Input 2"}
                    
                    { output = "limiter:Output 1" input = "convLT:In"}
                    { output = "limiter:Output 1" input = "convLW:In"}
                    { output = "limiter:Output 2" input = "convRT:In"}
                    { output = "limiter:Output 2" input = "convRW:In"}
                    
                    { output = "convLW:Out" input = "LW:In"}
                    { output = "convRW:Out" input = "RW:In"}
                    { output = "convLW:Out" input = "LW2:In"}
                    { output = "convRW:Out" input = "RW2:In"}
                ]

                inputs = [ "bass:in_l" "bass:in_r" ]
                
                # changed the outputs order
                # following 16,1 2019 model at /System/Library/Audio/Tunings/Mac-E1008331FDC96864/DSP/Graphs/builtin_speaker_out.dspg
                # [def numChansOut 6] ; rdar://46105807; Mapping Ch 0 - Ch 5; Left woofer 1, left woofer 2, left tweeter, right woofer 1, right woofer 2, right tweeter as of 12/03/18
                outputs = [ 
                            "LW:Out"
                            "LW2:Out"
                            "convLT:Out"
                            "RW:Out"
                            "RW2:Out"
                            "convRT:Out"
                            ]
            }
            capture.props = {
                node.name = "effect_input.filter-chain-speakers"
                media.class = Audio/Sink
                audio.channels = 2
                audio.position = [ FL FR ]
            }

            playback.props = {
                node.name = "effect_output.filter-chain-speakers"
                node.target = "alsa_output.pci-0000_04_00.3.Speakers"
                node.passive = true
                audio.channels = 6
                audio.position = [ AUX0 AUX1 AUX2 AUX3 AUX4 AUX5 ]
            }
        }
    }
]
