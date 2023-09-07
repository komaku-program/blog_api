Rails.application.config.session_store :cookie_store,
                                       key: '_your_app_session',
                                       secure: Rails.env.production?,  # HTTPSを使用する場合はこのフラグをtrueに設定
                                       same_site: :lax,  # オプションは :strict, :lax, :none から選べます
                                       expire_after: 14.days
