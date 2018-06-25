<depends>
    <div class="input-group">
        <select class="form-control depend-id" >
            <option
            each={field in getConfig()[opts.step].fields}
            value={field.id}
            >{stripTags(getLanguage()[parent.opts.step][field.text])}</option>
        </select>
        <div class="input-group-btn">
            <a class="btn btn-default" onclick={addDepend}>{getLanguage().general.text_add}</a>
        </div>
    </div>
    <div each={depend, depend_id in opts.depends }>
        <depend_setting 
            depend_id={depend_id} 
            if={depend}
            depend={depend} 
            field_id={ parent.opts.field_id } 
            step={parent.opts.step} 
            edit="{parent.opts.edit}"></depend_setting>
    </div>
    
    <script>
        var tag = this;

        addDepend(e){
            var depend_id = $(tag.root).find('.depend-id').val();
            tag.store.dispatch('field/addDepend', {'step_id': tag.opts.step, 'field_id': tag.opts.field_id, 'depend_id': depend_id});
        }
    </script>
</depends>