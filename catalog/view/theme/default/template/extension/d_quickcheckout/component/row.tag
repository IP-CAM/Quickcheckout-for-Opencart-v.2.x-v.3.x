<row class="row gr gr-row gr-has-controls">
    <virtual if={getState().edit}>
        <div class="gr-control gr-row-control">
            <a class="gr-btn gr-add-col" onclick={addCol}><i class="fa fa-clone"></i> Add column</a> 
            <a class="gr-btn gr-remove-row" onclick={removeRow}><i class="fa fa-times"></i></a>
            <span class="gr-label">ROW</span>
        </div>
        <div class="gr-row-border-top"></div>
        <div class="gr-row-border-right"></div>
        <div class="gr-row-border-bottom"></div>
        <div class="gr-row-border-left"></div>
        <div class="gr-row-content">
            <div 
            each={ col, col_id in opts.row.children }
            id={col_id}
            col={col}
            col_id={col_id}
            class="col-sm-{ col.size } gr gr-col"
            no-reorder
            data-is="col">
            </div>
        </div>
    </virtual>
    <virtual if={!getState().edit}>
        <div 
        each={ col, col_id in opts.row.children }
        id={col_id}
        col={col}
        col_id={col_id}
        class="col-sm-{ col.size }"
        data-is="col">
        </div>
    </virtual>

    <script>
        var tag = this;
        var state = this.store.getState();

        addCol(){
            var sort_order = tag.store.countItems(tag.opts.row.children);
            tag.store.dispatch('col/add', {parent : tag.opts.row.id, sort_order: sort_order});
        }

        removeRow(){
            tag.store.dispatch('row/remove', {row_id: tag.opts.row_id});
        }
    </script>
</row>