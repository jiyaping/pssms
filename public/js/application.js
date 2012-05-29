/*
* 作者		: 	jiyaping
* 日期		: 	2012-05-25
* 用途		：	信息转化
*/
function InfoChange(id,value){
	//0代表性别信息 (“0”：男，”1“:女)
	if(id==0){
		switch(value){
			case "0":
				return "男";
			case "1":
				return "女";
			default:
				return "";
		}
	}

	//1 代表权限 (“0”：管理员 "1":采购员 ”2“：库管员 "3":货物管理员 “4”：销售员 "5"；会计)
	if(id==1){
		switch(value){
			case "0":
				return "管理员";
			case "1":
				return "采购员";
			case "2":
				return "库管员";
			case "3":
				return "货物管理员";
			case "4":
				return "销售员";
			case "5":
				return "会计";
			default:
				return "";
		}
	}

	//2代表废止区分("0" :启用 “1":停用)
	if(id==2){
		switch(value){
			case "0":
				return "启用";
			case "1":
				return "停用";
			default:
				return "";
		}
	}

	//3代表审核 ("0" :通过 “1":未通过 ”2“:未审核)
	if(id==3){
		switch(value){
			case "0":
				return "通过";
			case "1":
				return "未通过";
			case "2":
				return "未审核";
			default:
				return "";
		}
	}

	//4代表入出库理由(00:商品入库 01:商品退库 02:商品上架 03:商品正常下架 04:过期商品入库 05:不合格品入库)
	if(id==4){
		switch(value){
			case "00":
				return "商品入库";
			case "01":
				return "商品退库";
			case "02":
				return "商品上架";
			case "03":
				return "商品正常下架";
			case "04":
				return "过期商品入库";
			case "05":
				return "不合格品入库";
			default:
				return "";
		}
	}

	//5代表入/退库区分("0" :入库 “1":退库)
	if(id==5){
		switch(value){
			case "0":
				return "入库";
			case "1":
				return "退库";
			default:
				return "";
		}
	}

	//6代表货架类型(00:普通货架 01:柜台 02:冷藏柜 03:其他)
	if(id==6){
		switch(value){
			case "00":
				return "普通货架";
			case "01":
				return "柜台";
			case "02":
				return "冷藏柜";
			case "03":
				return "其他";
			default:
				return "";
		}
	}

	//7代表上/下架区分("0" :上架 “1":下架)
	if(id==7){
		switch(value){
			case "0":
				return "上架";
			case "1":
				return "下架";
			default:
				return "";
		}
	}

	//8代表应收应付区分("0" :应收 “1":应付)
	if(id==8){
		switch(value){
			case "0":
				return "应收";
			case "1":
				return "应付";
			default:
				return "";
		}
	}

	//9代表目标类型(00:供应商 01:货架)
	if(id==9){
		switch(value){
			case "00":
				return "供应商";
			case "01":
				return "货架";
			default:
				return "";
		}
	}

	//10代表主子明细区分(0:主明细 1:子明细)
	if(id==10){
		switch(value){
			case "0":
				return "主明细";
			case "1":
				return "子明细";
			default:
				return "";
		}
	}

	//11代表费用原因(00:商品入库 01:商品退库 02:商品出售 03:商品退货)
	if(id==11){
		switch(value){
			case "00":
				return "商品入库";
			case "01":
				return "商品退库";
			case "02":
				return "商品出售";
			case "03":
				return "商品退货";
			default:
				return "";
		}
	}
}

/*
* 调试用 查看js的属性信息
*/
function ViewObject(obj){
	str = "";
	for(p in obj){
		str=str + p + ":"+eval("obj."+p)+"\n";
	}
	alert(str);
}

function ViewAttr(obj){
	str = "";
	for(p in obj){
		str=str + p +"\n";
	}
	alert(str);
}


