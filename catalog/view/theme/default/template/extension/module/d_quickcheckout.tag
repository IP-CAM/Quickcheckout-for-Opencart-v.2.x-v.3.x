<d_quickcheckout>
    
    <div if={!getSession().status}>
      <h1>{getLanguage().general.text_cart_title}</h1>
      <p>{getLanguage().general.text_cart_empty}</p>
    </div>

    <div if={getSession().status}>
        <div class="loader" style="display:none">{getLanguage().general.text_loading}</div>

        <setting 
        if={getState().edit} 
        setting_id={setting_id}
        title={getLanguage().general.text_general} >
            <div class="form-group">
                <label class="control-label">{getLanguage().general.text_display} {getLanguage().general.text_header_footer}</label>
                <div>
                    <switcher 
                    onclick="{parent.edit}" 
                    name="layout[header_footer]" 
                    data-label-text="Enabled" 
                    value={ getLayout().header_footer } />
                </div>
            </div>
            <div class="form-group">
                <label class="control-label">{getLanguage().general.text_display} {getLanguage().general.text_breadcrumb}</label>
                <div>
                    <switcher 
                    onclick="{parent.edit}" 
                    name="layout[breadcrumb]" 
                    data-label-text="Enabled" 
                    value={ getLayout().breadcrumb } />
                </div>
            </div>

            <div class="form-group">
                <label class="control-label"> {getLanguage().general.text_layout}</label><br/>
                <select
                    class="form-control"
                    onchange="{parent.changeLayout}" >
                    <option
                        each={layout in getState().layouts }
                        if={layout}
                        value={ layout }
                        selected={ layout == getLayout().codename} >
                        { layout } 
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label class="control-label"> {getLanguage().general.text_skin}</label><br/>
                <select
                    class="form-control"
                    onchange="{parent.changeSkin}" >
                    <option
                        each={skin in getState().skins }
                        if={skin}
                        value={ skin }
                        selected={ skin == getSession().skin} >
                        { skin } 
                    </option>
                </select>
            </div>


            <div class="form-group">
                <label class="control-label"> {getLanguage().general.text_reset}</label><br/>
                <a class="btn btn-danger" onclick={parent.resetState}>{getLanguage().general.text_reset}</a>
            </div>
        </setting>

        <div class="editor" if={getState().edit}>
            <div class="editor-heading">
                <span>{getLanguage().general.text_editor_title} {getSession().setting_name}</span>
            </div>
            <div class="editor-control">
                <a class="btn btn-lg btn-primary" onclick={toggleSetting}><i class="fa fa-cog"></i></a>
                <a class="btn btn-lg btn-success" onclick={saveState}>{getLanguage().general.text_update}</a>
                <a class="btn btn-lg btn-danger" href="{this.store.getState().close}" target="_parent"><i class="fa fa-close"></i></a>
            </div>
            <div class="editor-account">
                <div class="btn-group btn-group" data-toggle="buttons">
                    <label class="btn btn-lg btn-primary { getAccount() == 'guest' ?  'active' : '' }" onclick={changeAccount}>
                        <input type="radio" name="account" value="guest" id="guest" autocomplete="off" checked={ getAccount() == 'guest' }> {getLanguage().account.entry_guest}
                    </label>
                    <label class="btn btn-lg btn-primary { getAccount() == 'register' ?  'active' : '' }" onclick={changeAccount}>
                        <input type="radio" name="account" value="register" id="register" autocomplete="off" checked={ getAccount() == 'register' }> {getLanguage().account.entry_register}
                    </label>
                </div>
            </div>
            <div class="editor-language" if={Object.keys(getState().languages).length  > 1}>
                <div class="btn-group btn-group" data-toggle="buttons">
                    <label each={language, language_id in getState().languages} class="btn btn-lg btn-primary { getSession().language == language_id ?  'active' : '' }" onclick={changeLanguage}>
                        <input type="radio" name="language" value="{language_id}" id="{language_id}" autocomplete="off" checked={ getSession().language == language_id }> {language.name}
                    </label>
                </div>
            </div>
            <div class="editor-pro" if={ !getState().pro }>
                <a onclick="{getPro}" class="label label-warning">get PRO</a>
            </div>
        </div>

        <layout></layout>
    </div>

    <script>
        var state = this.store.getState();

        this.setting_id = 'general_setting';

        toggleSetting(e){
            if($('#'+ this.setting_id).hasClass('show')){
                this.store.hideSetting()
            }else{
                this.store.showSetting(this.setting_id);
            }
        }

        edit(e){
            this.store.dispatch('setting/edit', $('#'+this.setting_id).find('form').serializeJSON());
        }

        saveState(e){
            this.store.dispatch('setting/save');
        }

        resetState(e){
            this.store.dispatch('setting/reset');
        }

        changeAccount(e){
            this.store.dispatch('account/update', { account: $(e.currentTarget).find('input').val()});
        }

        changeLanguage(e){
            this.store.dispatch('setting/changeLanguage', { language_id: $(e.currentTarget).find('input').val()});
        }

        changeLayout(e){
            this.store.dispatch('setting/changeLayout', { layout_codename: $(e.currentTarget).val()});
        }

        changeSkin(e){
            this.store.dispatch('setting/changeSkin', { skin_codename: $(e.currentTarget).val()});
        }

        getPro(){
            alertify.defaults.theme.ok = "btn btn-primary";
            alertify.defaults.theme.cancel = "btn btn-danger";
            alertify.defaults.theme.input = "form-control";
            alertify.alert('Ajax Quick Checkout PRO','<strong>Need more flexibility?</strong> Unlock PRO features like field settings, step settings, page settings, layouts and themes. <br/><br/><a target="_blank" href="http://dreamvention.ee/1a3b3300">-10% Coupon AQC7FREE</a> <br/><br/> <strong>Upgrade</strong> to the Aajx Quick Checkout PRO version today.')
        }

        setStyles(){

            $.when($.get('catalog/view/theme/default/stylesheet/d_quickcheckout/skin/'+this.store.getSession().skin+'/'+this.store.getSession().skin+'.css?'+this.store.rand()))
            .done(function(response) {
                $('html > head').find('[title="d_quickcheckout"]').remove();

                var style = '<style title="d_quickcheckout">';
                style += response;

                style += this.store.buildStyleBySelector('body > *', {
                    'display': (this.store.getLayout().header_footer == 1) ? 'block' :'none'
                })

                style += this.store.buildStyleBySelector('body > d_quickcheckout', {
                    'padding': (this.store.getLayout().header_footer == 1) ? '0px' :'40px',
                    'display': (this.store.getLayout().header_footer == 1) ? 'block' :'block'
                })

                style += this.store.buildStyleBySelector('.qc-breadcrumb', {
                    'display': (this.store.getLayout().breadcrumb == 1) ? 'block' :'none'
                })

                style += '</style>'; 

                $('html > head').append($(style));

                if(this.store.getLayout().header_footer != 1){
                    $('body').prepend($('#d_quickcheckout'));
                }else{
                    $('.spinner').after($('#d_quickcheckout'));
                }

            }.bind(this));

        }

        this.on('mount', function(){
            if(this.store.getState().edit){
                this.setStyles();
            }
            
        })

        this.on('update', function(){
            if(this.store.getState().edit){
                this.setStyles();
            }
        })
    </script>
</d_quickcheckout>