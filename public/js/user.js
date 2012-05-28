$(function(){
		$('#dg').datagrid({
            iconCls:"icon-ok",
            fit:true,
            loadMsg:'数据加载中请稍后……',
            pageSize:13,
            height:200,
            pageList:[13,20,50,100],
            striped:true,
            url:"/user",
            idField:"id",
            singleSelect:true,
            columns:[[
                {field:'id',title:'key',rowspan:2,align:'center',editor:'numberbox',hidden:true},
                {field:'real_name',title:'姓名',width:80,rowspan:2,align:'center',editor:'text'},
                {field:'login_id',title:'登录名',width:100,rowspan:2,align:'center',editor:'text'},
                {field:'password',title:'密码',width:80,rowspan:2,align:'center',editor:'text'},
                {field:'privilege',title:'权限',width:80,rowspan:2,align:'center',editor:'text',
                    formatter:function(value,row,index){
                        return InfoChange(1,value);
                    }
                },
                {field:'gender',title:'性别',width:40,rowspan:2,align:'center',editor:'text',
                    formatter:function(value,row,index){
                        return InfoChange(0,value);
                    }
                },
                {field:'ceilphone',title:'手机',width:100,rowspan:2,align:'center',editor:'text'},
                {field:'qq',title:'QQ',width:100,rowspan:2,align:'center',editor:'text'},
                {field:'email',title:'邮箱',width:100,rowspan:2,align:'center',editor:{
                    type:'validatebox',
                    options:{
                        validType:'email'
                    }
                }},
                {field:'address',title:'地址',width:120,rowspan:2,align:'center',editor:'text'},
                {field:'last_login',title:'上次登录时间',width:80,rowspan:2,align:'center',editor:'text'},
                {field:'operator',title:'操作列',width:70,rowspan:2,align:'center',
                    formatter:function(value,row,index){
                        if(row.editing){
                            var s ='<a href="javascript:void(0);" onclick="saveRow('+index+')" style="text-decoration: none;color: #800080;">保存</a>  ';
                            var c ='<a href="javascript:void(0);" onclick="cancelRow('+index+')" style="text-decoration: none;color: #800080;">取消</a>';
                            return s+c;
                        }else{
                            var e = '<a href="javascript:void(0);" onclick="editRow('+index+')" style="text-decoration: none;color: #800080;">编辑</a> ';
                            var d = '<a href="javascript:void(0);" onclick="deleteRow('+index+')" style="text-decoration: none;color: #800080;">删除</a>';
                            return e+d;
                        }
                    }
                },
                {field:'user_flag',hidden:true},
                {field:'add_id',hidden:true},
                {field:'add_date',hidden:true},
                {field:'upd_id',hidden:true},
                {field:'upd_date',hidden:true}
                ]],
            pagination:true,
            rownumbers:true,
            toolbar:[{
                text:'增加',
                iconCls:'icon-add',
                handler:addRow
            },'-',{
                text:'查询',
                iconCls:'icon-search',
                handler:function(){
                    $('#query').window('open');
                }
              }
            ],
            onBeforeEdit:function(index,row){
                row.editing = true;
                $('#tt').datagrid('refreshRow',index);
                count++;
            },
            onAfterEdit:function(index,row){
                row.editing = true;
                $('#tt').datagrid('refreshRow',index);
                count--;
            },
            onCancelEdit:function(index,row){
                row.editing = false;
                $('#tt').datagrid('refreshRow',index);
                count--;
            }
		});
	});
    var count = 0;
    function editRow(index){
        $('#dg').datagrid('beginEdit',index);
        alert($("dg"));
    }
    function deleteRow(index){
        var selected = $('#dg').datagrid('getSelected');
        if(selected){
        $.messager.confirm('删除','确认删除吗?',function(d){
            if(d){
            $.ajax({
                type:"POST",
                url:"/user/delete",
                data:"id="+selected.id,
                success:function(data){
                    if(data!=""){
                        $.messager.alert('warning',data);
                    }else{
                        $('#dg').datagrid('deleteRow',index);
                    }
                }
            });
            }
        });
        }
    }
    function saveRow(index){
        $('#dg').datagrid('endEdit',index);
        /*
         * 将数据保存到数据库
         * */
        var select = $('#dg').datagrid('getSelected');
        var arr =new Array(); //将信息保存在数组中
        arr[0]= select.id;
        arr[1]= select.name;
        arr[2]= select.email;
        arr[3]= select.qq;
        arr[4]= select.birthday;
        arr[5]=select.address;
        if(select){
            $.ajax({
            type:'POST',
            url:'queryId.action',
            data:'id='+select.id,
            success:function(data){
                if(data=='0'){
                    $.messager.alert('error','学号'+select.id+'已存在,请重新编辑','error',function(){
                        $('#dg').datagrid('beginEdit', index);
                    });
                }else{
                    save(arr,index);
                }
            }
        });
        }
    }
    function cancelRow(index){
        $('#dg').datagrid('cancelEdit',index);
    }
    function addRow(){
        if(count>0){
            $.messager.alert('warning','当前还有'+count+'记录正在编辑,请保存','warning');
            return ;
        }else{
            $('#dg').datagrid('endEdit', lastIndex);
            $('#dg').datagrid('appendRow',{
                id:'',
                login_id:'',
                password:'',
                real_name:'',
                ceilphone:'',
                qq:'',
                address:'',
                gender:'',
                email:'',
                privilege:'',
                user_flag:'',
                last_login:''
            });
            var lastIndex = $('#dg').datagrid('getRows').length-1;
            alert($('#dg'));
            $('#dg').datagrid('selectRow', lastIndex);alert($('#dg'));
            $('#dg').datagrid('beginEdit', lastIndex);
            alert($('#dg'));
        } 
    }
    
    function save(arr,index){
        $.ajax({
            type:'POST',
            url:'saveInfo.action',
            data:'arr='+arr,
            success:function(data){
                if(data){
                    $.messager.alert('warning',data,'warning',function(){
                        $('#dg').datagrid('beginEdit', index);
                    })
                }else{
                    $('#dg').datagrid('reload');
                }
            }
        });
    }
    function query(){
        var queryParams = $('#dg').datagrid('options').queryParams;
        queryParams.queryWord = $('#qq').val();
        queryParams.queryType = $('#ss').val();
        $('#dg').datagrid({
            url:'queryInfo.action'
        });
        $('#query').window('close');
    }