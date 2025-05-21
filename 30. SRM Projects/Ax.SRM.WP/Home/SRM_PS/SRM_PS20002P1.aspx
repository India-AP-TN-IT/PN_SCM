<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SRM_PS20002P1.aspx.cs" Inherits="Ax.EP.WP.Home.SRM_PS.SRM_PS20002P1" %>
<%@ Register Assembly="Ext.Net" Namespace="Ext.Net" TagPrefix="ext" %>
<%@ Register Src="~/Home/EPControl/EPCodeBox.ascx" tagname="EPCodeBox" tagprefix="epc" %>  
<!DOCTYPE html>
<html>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="text/html; charset=UTF-8" http-equiv="content-type">
<meta content="/images/favicon/SCM.ico" itemprop="image">
<meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

<head id="Head1" runat="server">
    <meta content="IE=edge" http-equiv="X-UA-Compatible">
    <meta content="text/html; charset=UTF-8" http-equiv="content-type">
    <meta content="/images/favicon/SCM.ico" itemprop="image">
    <meta name="apple-mobile-web-app-title" content="Ax.POTAL" />

    <title>원가계산서</title>

    <link rel="shortcut icon" type="image/x-icon" href="/images/favicon/SCM.ico" />
    <link rel="Stylesheet" type="text/css" href="../../css/style.css?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>"  />
    <style type = "text/css">
        
        .inputText_Num {height: 18px;vertical-align:middle;text-align:right;/*display:inline;border:#d2d2d2 1px solid;*/}
        .changeColorYellow .x-form-text{
             background:yellow !important;
        } 
        .changeColorWhite .x-form-text{
             background:white !important;
        }                  
    </style>
    <script src="../../Script/Common.js?v=<%=Ax.EP.Utility.EPAppSection.ToString("SYSTEM_VER") %>" type="text/javascript"></script>
    <script type="text/javascript">

        function UI_Shown() {
            this.UI_Resize();
        }
        function test() {
            alert('test');
        }
        // UI_Resize 는 UIContainer 의 Viewport 에서 Resize Listener 을 통해 호출 ( 아래 Viewport 태그 참고 )
        function UI_Resize() {
            App.InputPanel.setHeight(1600);
        }

        // 콤보에 없는 데이터일 경우에는 javascript에서만 setvalue가 됨(combobox가 editable=true인것)
        function setValueCombo(id, value) {
            var _id = Ext.getCmp(id);
            _id.setValue(value);
            //4.X에서 수정, 보기일경우에 데이터 바인딩 이후에 CALC가 실행이 되도록 히든처리
            App.txt01_initCheck.setValue("1");
        }

        function SetMaterialUcost(depth, value) {
            var material_ucost = Ext.getCmp('cbo' + depth + '_MATERIAL_UCOST_H');
            material_ucost.setValue(value);
        }

        function SetCtime(depth, value) {
            var ctime = Ext.getCmp('cbo' + depth + '_CTIME_H');
            ctime.setValue(value);
        }

        // 엑셀 스타일의 반올림 함수 정의
        function roundXL(n, digits) {
            if (digits >= 0) return parseFloat(n.toFixed(digits)); // 소수부 반올림

            digits = Math.pow(10, digits); // 정수부 반올림
            var t = Math.round(n * digits) / digits;

            return parseFloat(t.toFixed(0));
        }

        //가공비

        function changeProcCtime(value, depth) {
            var proc = Ext.getCmp('cbo' + depth + '_PROC'); //재질
            App.direct.ChangeProcCtime(proc.getValue(), depth, "");
        }

        //select 리스터, change리스너 구분
        function ChangeProcess(_id, isSelect) {

            var id = _id.getId(); // ID            
            var value = Ext.getCmp(id).getValue(); //Value

            if ((isSelect == false && (value == '' || value == null)) || isSelect == true) { // change listner가 타고 value가 널일경우에 공백으로 세팅한다. 
                var depth = id.replace('cbo', '').replace('_PROC', ''); //01,02...                       
                changeProcCtime(value, depth);

                fn_top_hidden_change_proc(depth, true);
            }

        }

        // 분기문 마다 반복적으로 코드가 들어가는 이유는 : 각각의 콤보에 맞게 세팅이 이루어 질 가능성 또는 지고 있기 때문임
        function fn_top_hidden_change_proc(depth, check) {

            var ctime = Ext.getCmp('cbo' + depth + '_CTIME_H'); //C TIME            
            var cv = Ext.getCmp('txt' + depth + '_CV_H'); // cv
            var cv_original = Ext.getCmp('txt' + depth + '_CV'); // cv
            var man_qty = Ext.getCmp('txt' + depth + '_MAN_QTY'); // 인원
            var imyul = Ext.getCmp('txt' + depth + '_IMYUL'); // 임율
            var man_cost_total = Ext.getCmp('txt' + depth + '_MAN_COST_TOTAL_H'); // 노무비 금액
            var man_cost_total_original = Ext.getCmp('txt' + depth + '_MAN_COST_TOTAL'); // 노무비 금액
            var machine_cost = Ext.getCmp('txt' + depth + '_MACHINE_COST_H'); // 기계경비
            var machine_cost_original = Ext.getCmp('txt' + depth + '_MACHINE_COST'); // 기계경비

            var machine_cost_total = Ext.getCmp('txt' + depth + '_MACHINE_COST_TOTAL_H'); // 경비금액
            var machine_cost_total_original = Ext.getCmp('txt' + depth + '_MACHINE_COST_TOTAL'); // 경비금액

            var cost_total = Ext.getCmp('txt' + depth + '_COST_TOTAL_H'); // 가공비
            var cost_total_original = Ext.getCmp('txt' + depth + '_COST_TOTAL'); // 가공비

            var machine_nm = Ext.getCmp('txt' + depth + '_MACHINE_NM'); // 가공비
            var value = Ext.getCmp('cbo' + depth + '_PROC').getValue();

            machine_nm.setValue('');

            ctime.setValue('');
            cv.setValue('');
            cv_original.setValue('');
            man_qty.setValue('');

            man_cost_total.setValue('');
            man_cost_total_original.setValue('');

            machine_cost.setValue('');
            machine_cost_original.setValue('');

            machine_cost_total.setValue('');
            machine_cost_total_original.setValue('');

            cost_total.setValue('');
            cost_total_original.setValue('');


            if (check == true) {
                cv_original.removeCls('changeColorYellow');
                man_qty.removeCls('changeColorYellow');
                var temp_ctime = 0;
                if (value == 'BOX조립') {
                    man_qty.setValue('1');
                    cv.setValue('');
                    cv_original.setValue('');
                    temp_ctime = '30';
                    cv_original.addCls('changeColorYellow');
                    man_qty.addCls('changeColorYellow');
                    App.direct.ChangeSetCtime(temp_ctime, depth);

                } else if (value == '제품적입') {
                    man_qty.setValue('1');
                    var temp_ctime = 0;
                    if (App.cbo01_PART_DIV.getValue() == '사출표면처리폼') {
                        temp_ctime = 10;
                    } else {
                        if (App.txt01_LOAD_QTY.getValue() >= 300) temp_ctime = 1;
                        else temp_ctime = 2;

                    }

                    cv.setValue(App.txt01_LOAD_QTY.getValue());
                    cv_original.setValue(App.txt01_LOAD_QTY.getValue());
                    cv_original.addCls('changeColorYellow');
                    man_qty.addCls('changeColorYellow');
                    App.direct.ChangeSetCtime(temp_ctime, depth);
                } else if (value == '격자조립') {
                    man_qty.setValue('1');
                    var temp_ctime = 0;
                    if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 4) temp_ctime = 20;
                    else if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 6) temp_ctime = 30;
                    else if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 10) temp_ctime = 35;
                    else if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 15) temp_ctime = 40;
                    else temp_ctime = 70;

                    cv.setValue(App.txt01_LOAD_Z.getValue());
                    cv_original.setValue(App.txt01_LOAD_Z.getValue());
                    cv_original.addCls('changeColorYellow');
                    man_qty.addCls('changeColorYellow');
                    App.direct.ChangeSetCtime(temp_ctime, depth);
                }
                else if (value == '마무리') {
                    temp_ctime = '25';
                    man_qty.setValue('1');
                    cv.setValue('');
                    cv_original.setValue('');
                    cv_original.addCls('changeColorYellow');
                    man_qty.addCls('changeColorYellow');
                    App.direct.ChangeSetCtime(temp_ctime, depth);
                }
                else {
                    temp_ctime = '';
                    man_qty.setValue('1');
                    cv.setValue('');
                    cv_original.setValue('');
                    cv_original.addCls('changeColorYellow');
                    man_qty.addCls('changeColorYellow');
                    ctime.setValue(temp_ctime);
                }
            }

            //수정된 행만 재계산한다.
            CalcProc('', depth, Ext.getCmp('cbo' + depth + '_PROC').getValue(), check);
        }

        function ProcStyle(depth) {
            var cv_original = Ext.getCmp('txt' + depth + '_CV'); // cv
            cv_original.addCls('changeColorYellow');

            var man_qty = Ext.getCmp('txt' + depth + '_MAN_QTY'); // 인원
            man_qty.addCls('changeColorYellow');
        }

        function CalcProc(id, depth, value, check) {
            //4.X에서 calc가 먼저 타는 현상이 생겨서 특정 조건일 경우에 탈 수 있도록 변경
            if (App.hid01_MODE.getValue() != 'N' && App.txt01_initCheck.getValue() == '') return
            var ctime = Ext.getCmp('cbo' + depth + '_CTIME_H'); //C TIME            
            var cv = Ext.getCmp('txt' + depth + '_CV_H'); // cv
            var cv_original = Ext.getCmp('txt' + depth + '_CV'); // cv
            var man_qty = Ext.getCmp('txt' + depth + '_MAN_QTY'); // 인원
            var imyul = Ext.getCmp('txt' + depth + '_IMYUL'); // 임율
            var man_cost_total = Ext.getCmp('txt' + depth + '_MAN_COST_TOTAL_H'); // 노무비 금액
            var man_cost_total_original = Ext.getCmp('txt' + depth + '_MAN_COST_TOTAL'); // 노무비 금액
            var machine_cost = Ext.getCmp('txt' + depth + '_MACHINE_COST_H'); // 기계경비
            var machine_cost_original = Ext.getCmp('txt' + depth + '_MACHINE_COST'); // 기계경비

            var machine_cost_total = Ext.getCmp('txt' + depth + '_MACHINE_COST_TOTAL_H'); // 경비금액
            var machine_cost_total_original = Ext.getCmp('txt' + depth + '_MACHINE_COST_TOTAL'); // 경비금액

            var cost_total = Ext.getCmp('txt' + depth + '_COST_TOTAL_H'); // 가공비
            var cost_total_original = Ext.getCmp('txt' + depth + '_COST_TOTAL'); // 가공비

            if (value == 'BOX조립') {
                //경비 금액
                machine_cost_total.setValue(machine_cost.getValue() * (ctime.getValue() / 3600));
                machine_cost_total_original.setValue(machine_cost.getValue() * (ctime.getValue() / 3600));
            } else if (value == '제품적입') {


            } else if (value == '격자조립') {


            } else {
            }

            //임율

            if (check == true && App.cbo01_VEND_DIV.getValue() == '1차사') {
                imyul.setValue('9300');
            } else if (check == true && App.cbo01_VEND_DIV.getValue() == '2차사') {
                imyul.setValue('8700');
            }

            //노무비 금액            
            man_cost_total.setValue(imyul.getValue() * cv.getValue() * (ctime.getValue() / 3600) * man_qty.getValue());
            man_cost_total_original.setValue(imyul.getValue() * cv.getValue() * (ctime.getValue() / 3600) * man_qty.getValue());

            //가공비 (노무비 + 경비)
            cost_total.setValue(man_cost_total.getValue() + machine_cost_total.getValue());
            cost_total_original.setValue(man_cost_total.getValue() + machine_cost_total.getValue());

            sum_manufacture(); //가공비합계
        }

        //가공비 합산
        function sum_manufacture() {
            var sum_val = 0;
            for (var i = 1; i < 7; i++) {
                sum_val += Ext.getCmp('txt0' + i + '_COST_TOTAL_H').getValue(); ;
            }
            sum_val = Math.floor(sum_val);

            App.txt01_MANUFATUR_SUM.setValue(sum_val);
            App.txt01_MANUFATUR_SUM_H.setValue(sum_val);

            TotalSum();

        }

        function ChangeImyul(value) {
            for (var i = 1; i < 7; i++) {
                if (Ext.getCmp('cbo0' + i + '_PROC').getValue() != null && Ext.getCmp('cbo0' + i + '_PROC').getValue() != '') {
                    if (value == '1차사') {
                        Ext.getCmp('txt0' + i + '_IMYUL').setValue('9300');
                    }
                    else {
                        Ext.getCmp('txt0' + i + '_IMYUL').setValue('8700');
                    }
                }
            }
        }

        function ChangPartDiv(value) {

            //            for (var i = 1; i < 7; i++)
            //            {                  
            //                if(Ext.getCmp('cbo0' + i + '_PROC').getValue() =='제품적입')
            //                {
            //                    // 제품접입일경우에 cv에 값을 넣어준다.
            //                    Ext.getCmp('txt0' + i + '_CV').setValue(App.txt01_LOAD_QTY.getValue());
            //                    Ext.getCmp('txt0' + i + '_CV_H').setValue(App.txt01_LOAD_QTY.getValue());

            //                    var temp_ctime = 0;
            //                    if (App.cbo01_PART_DIV.getValue() == '사출표면처리폼') {
            //                        temp_ctime = 10;
            //                    } else {
            //                        if (App.txt01_LOAD_QTY.getValue() >= 300) temp_ctime = 1;
            //                        else temp_ctime = 2;

            //                    }    
            //                    Ext.getCmp('cbo0' + i + '_CTIME_H').setValue(temp_ctime);
            //                    
            //                }
            //            }

            fn_top_change();
        }



        //재료비        
        function changeMaterialUcost(value, depth) {
            var material = Ext.getCmp('cbo' + depth + '_MATERIAL'); //재질
            App.direct.ChangeMaterialCost(material.getValue(), depth, "");
        }

        function ChangeMaterial(_id, isSelect) {
            var id = _id.getId(); // ID            
            var value = Ext.getCmp(id).getValue(); //Value
            var depth = id.replace('cbo', '').replace('_PACK_MATERIAL', ''); //01,02...


            if ((isSelect == false && (value == '' || value == null)) || isSelect == true) { // change listner가 타고 value가 널일경우에 공백으로 세팅한다.                


                var remark = Ext.getCmp('txt' + depth + '_REMARK'); remark.setValue('');
                var part_size_x = Ext.getCmp('txt' + depth + '_PART_SIZE_X'); part_size_x.setValue(''); // 규격x
                var part_size_y = Ext.getCmp('txt' + depth + '_PART_SIZE_Y'); part_size_y.setValue(''); // 규격y
                var part_size_z = Ext.getCmp('txt' + depth + '_PART_SIZE_Z'); part_size_z.setValue(''); // 규격z            
                var us = Ext.getCmp('txt' + depth + '_PART_USAGE'); us.setValue(''); //usage        

                var u_cost_original = Ext.getCmp('txt' + depth + '_UCOST'); u_cost_original.setValue(''); //원단가
                var u_cost = Ext.getCmp('txt' + depth + '_UCOST_H'); u_cost.setValue(''); //원단가            

                var u_cost_add_original = Ext.getCmp('txt' + depth + '_UCOST_ADD'); u_cost_add_original.setValue(''); //보정단가            
                var u_cost_add = Ext.getCmp('txt' + depth + '_UCOST_ADD_H'); u_cost_add.setValue(''); //보정단가                        

                var u_cost_total_original = Ext.getCmp('txt' + depth + '_UCOST_TOTAL'); u_cost_total_original.setValue('');
                var u_cost_total = Ext.getCmp('txt' + depth + '_UCOST_TOTAL_H'); u_cost_total.setValue('');

                var jang_original = Ext.getCmp('txt' + depth + '_JANG'); jang_original.setValue(''); //장절        
                var jang = Ext.getCmp('txt' + depth + '_JANG_H'); jang.setValue(''); //장절            

                var pok_original = Ext.getCmp('txt' + depth + '_POK'); pok_original.setValue(''); //지폭
                var pok = Ext.getCmp('txt' + depth + '_POK_H'); pok.setValue(''); //지폭

                var jaejok_original = Ext.getCmp('txt' + depth + '_JAEJOK'); jaejok_original.setValue(''); //재적
                var jaejok = Ext.getCmp('txt' + depth + '_JAEJOK_H'); jaejok.setValue(''); //재적

                var ingredient_ucost_original = Ext.getCmp('txt' + depth + '_INGREDIENT_UCOST'); ingredient_ucost_original.setValue(''); //재료비
                var ingredient_ucost = Ext.getCmp('txt' + depth + '_INGREDIENT_UCOST_H'); ingredient_ucost.setValue(''); //재료비

                var apply_jipok = Ext.getCmp('txt' + depth + '_APPLY_JIPOK'); apply_jipok.setValue(''); //지폭적용            
                var part_usage_unit = Ext.getCmp('cbo' + depth + '_PART_USAGE_UNIT'); part_usage_unit.setValue(''); //단위

                fn_top_hidden_change(depth, true);
            }
            else {
                MaterialStyle(depth, value);
            }
        }
        // 분기문 마다 반복적으로 코드가 들어가는 이유는 : 각각의 콤보에 맞게 세팅이 이루어 질 가능성 또는 지고 있기 때문임
        function MaterialStyle(depth, value) {
            var part_size_z = Ext.getCmp('txt' + depth + '_PART_SIZE_Z'); // 규격z           
            var us = Ext.getCmp('txt' + depth + '_PART_USAGE'); // 규격z                       
            var material_ucost = Ext.getCmp('cbo' + depth + '_MATERIAL_UCOST_H'); // 재질단가   
            var material = Ext.getCmp('cbo' + depth + '_MATERIAL'); // 재질   
            var part_usage_unit = Ext.getCmp('cbo' + depth + '_PART_USAGE_UNIT'); //단위

            us.removeCls('changeColorYellow');
            part_size_z.removeCls('changeColorYellow');
            material.removeCls('changeColorYellow');
            material_ucost.removeCls('changeColorYellow');
            part_usage_unit.removeCls('changeColorYellow');
            if (value == 'C/BOX') {
                material.addCls('changeColorYellow');
                material_ucost.addCls('changeColorYellow');
                us.addCls('changeColorYellow');
            }
            else if (value == 'C/PAD') {
                material.addCls('changeColorYellow');
                material_ucost.addCls('changeColorYellow');
                us.addCls('changeColorYellow');
            }
            else if (value == 'PE SHEET') {
                part_size_z.addCls('changeColorYellow');
                us.addCls('changeColorYellow');
            }
            else if (value == 'PE BAG') {
                part_size_z.addCls('changeColorYellow');
                us.addCls('changeColorYellow');

            }
            else if (value == 'VINYL BAG') {
                part_size_z.addCls('changeColorYellow');
                us.addCls('changeColorYellow');
            }
            else if (value == '격자 2 (세로)') {
                material.addCls('changeColorYellow');
                material_ucost.addCls('changeColorYellow');
                us.addCls('changeColorYellow');
            }
            else if (value == '격자 1 (가로)') {
                material.addCls('changeColorYellow');
                material_ucost.addCls('changeColorYellow');
                us.addCls('changeColorYellow');
            }
            else if (value == 'OPP TAPE') {
                us.addCls('changeColorYellow');
            }
            else if (value == '부품식별표') {
                us.addCls('changeColorYellow');
            }

            part_usage_unit.addCls('changeColorYellow');
        }

        // 분기문 마다 반복적으로 코드가 들어가는 이유는 : 각각의 콤보에 맞게 세팅이 이루어 질 가능성 또는 지고 있기 때문임
        function fn_top_hidden_change(depth, check) {

            var part_size_x = Ext.getCmp('txt' + depth + '_PART_SIZE_X'); // 규격x
            var part_size_y = Ext.getCmp('txt' + depth + '_PART_SIZE_Y'); // 규격y
            var part_size_z = Ext.getCmp('txt' + depth + '_PART_SIZE_Z'); // 규격z           
            var us = Ext.getCmp('txt' + depth + '_PART_USAGE'); // 규격z           

            var value = Ext.getCmp('cbo' + depth + '_PACK_MATERIAL').getValue();
            var material_ucost = Ext.getCmp('cbo' + depth + '_MATERIAL_UCOST_H'); // 재질단가   
            var material = Ext.getCmp('cbo' + depth + '_MATERIAL'); // 재질   

            var u_cost_original = Ext.getCmp('txt' + depth + '_UCOST'); //원단가
            var u_cost = Ext.getCmp('txt' + depth + '_UCOST_H'); //원단가                                    
            var remark = Ext.getCmp('txt' + depth + '_REMARK'); //비고
            var part_usage_unit = Ext.getCmp('cbo' + depth + '_PART_USAGE_UNIT'); //단위


            if (check == true) {
                remark.setValue('');
                us.removeCls('changeColorYellow');
                part_size_z.removeCls('changeColorYellow');
                material.removeCls('changeColorYellow');
                material_ucost.removeCls('changeColorYellow');
                part_usage_unit.removeCls('changeColorYellow');
                if (value == 'C/BOX') {

                    part_size_x.setValue(App.txt01_TOP_MID_X.getValue());
                    part_size_y.setValue(App.txt01_TOP_MID_Y.getValue());
                    part_size_z.setValue(App.txt01_TOP_MID_Z.getValue());
                    us.setValue('');
                    material.addCls('changeColorYellow');
                    material_ucost.addCls('changeColorYellow');
                    us.addCls('changeColorYellow');
                }
                else if (value == 'C/PAD') {
                    part_size_x.setValue(App.txt01_TOP_MID_X.getValue() - 20);
                    part_size_y.setValue(App.txt01_TOP_MID_Y.getValue() - 20);
                    us.setValue(App.txt01_LOAD_Z.getValue() + 1);
                    material.addCls('changeColorYellow');
                    material_ucost.addCls('changeColorYellow');
                    us.addCls('changeColorYellow');
                }
                else if (value == 'PE SHEET') {
                    part_size_x.setValue(App.txt01_TOP_MID_X.getValue() - 20);
                    part_size_y.setValue(App.txt01_TOP_MID_Y.getValue() - 20);
                    us.setValue(App.txt01_LOAD_Z.getValue() + 1);
                    part_size_z.addCls('changeColorYellow');
                    us.addCls('changeColorYellow');
                    remark.setValue('BAG 가공비 9원');
                }
                else if (value == 'PE BAG') {

                    part_size_x.setValue((Math.ceil((App.txt01_TOP_PART_X.getValue() + (App.txt01_TOP_PART_Z.getValue() / 2)) / 10) * 10) * 2);
                    part_size_y.setValue((Math.ceil((App.txt01_TOP_PART_Y.getValue() + (App.txt01_TOP_PART_Z.getValue() / 2)) / 10) * 10) * 2);
                    us.setValue(App.txt01_LOAD_QTY.getValue());
                    part_size_z.addCls('changeColorYellow');
                    us.addCls('changeColorYellow');
                    remark.setValue('BAG 가공비 9원');

                }
                else if (value == 'VINYL BAG') {
                    part_size_x.setValue((Math.ceil((App.txt01_TOP_PART_X.getValue() + (App.txt01_TOP_PART_Z.getValue() / 2)) / 10) * 10) * 2);
                    part_size_y.setValue((Math.ceil((App.txt01_TOP_PART_Y.getValue() + (App.txt01_TOP_PART_Z.getValue() / 2)) / 10) * 10) * 2);
                    us.setValue(App.txt01_LOAD_QTY.getValue());
                    remark.setValue('BAG 가공비 9원');
                    part_size_z.addCls('changeColorYellow');
                    us.addCls('changeColorYellow');

                }
                else if (value == '격자 2 (세로)') {

                    part_size_x.setValue(App.txt01_TOP_MID_X.getValue() - 20);
                    part_size_y.setValue(Math.floor((((App.txt01_TOP_MID_Z.getValue() - 30) - ((App.txt01_LOAD_Z.getValue() + 1) * 3)) / App.txt01_LOAD_Z.getValue())));
                    us.setValue((App.txt01_LOAD_Y.getValue() + 1) * App.txt01_LOAD_Z.getValue());
                    remark.setValue('톰슨비 50원');
                    material.addCls('changeColorYellow');
                    material_ucost.addCls('changeColorYellow');
                    us.addCls('changeColorYellow');
                }
                else if (value == '격자 1 (가로)') {
                    part_size_x.setValue(App.txt01_TOP_MID_Y.getValue() - 20);
                    part_size_y.setValue(Math.floor((((App.txt01_TOP_MID_Z.getValue() - 30) - ((App.txt01_LOAD_Z.getValue() + 1) * 3)) / App.txt01_LOAD_Z.getValue())));
                    us.setValue((App.txt01_LOAD_X.getValue() + 1) * App.txt01_LOAD_Z.getValue());
                    remark.setValue('톰슨비 50원');
                    material.addCls('changeColorYellow');
                    material_ucost.addCls('changeColorYellow');
                    us.addCls('changeColorYellow');
                }
                else if (value == 'OPP TAPE') {
                    us.setValue((App.txt01_TOP_MID_X.getValue() + 100) / 1000 * 2);
                    us.addCls('changeColorYellow');
                }
                else if (value == '부품식별표') {
                    us.setValue('2');
                    u_cost_original.setValue('25');
                    u_cost.setValue('25');
                    us.addCls('changeColorYellow');
                }

                else {
                    //material.setValue('');
                    us.setValue('');
                }
                part_usage_unit.addCls('changeColorYellow');
                material.setValue('');
                material_ucost.setValue('');
                //이전값이 빈값이 있을경우에 동일한 값이라고 이벤트가 타지 않아서 두번 태움
                //material.setValue(' '); // 빈값으로 적용시 direct method ChangeMaterialCost를 타면서 해당 값을 불러와서 재 세팅이 된다.                
                //material.setValue(''); // 빈값으로 적용시 direct method ChangeMaterialCost를 타면서 해당 값을 불러와서 재 세팅이 된다.
                App.direct.ChangeMaterialCost("", depth, "");
                //App.direct.test("aaaa");

            }

            //수정된 행만 재계산한다.
            Calc('', depth, Ext.getCmp('cbo' + depth + '_PACK_MATERIAL').getValue(), check);
        }

        function Calc(id, depth, value, check) {
            //4.X에서 calc가 먼저 타는 현상이 생겨서 특정 조건일 경우에 탈 수 있도록 변겨
            if (App.hid01_MODE.getValue() != 'N' && App.txt01_initCheck.getValue() == '') return

            var part_size_x = Ext.getCmp('txt' + depth + '_PART_SIZE_X'); // 규격x
            var part_size_y = Ext.getCmp('txt' + depth + '_PART_SIZE_Y'); // 규격y
            var part_size_z = Ext.getCmp('txt' + depth + '_PART_SIZE_Z'); // 규격z            

            var material_ucost = Ext.getCmp('cbo' + depth + '_MATERIAL_UCOST_H'); // 재질단가            
            var us = Ext.getCmp('txt' + depth + '_PART_USAGE'); //usage        

            var u_cost_original = Ext.getCmp('txt' + depth + '_UCOST'); //원단가
            var u_cost = Ext.getCmp('txt' + depth + '_UCOST_H'); //원단가            

            var u_cost_add_original = Ext.getCmp('txt' + depth + '_UCOST_ADD'); //보정단가            
            var u_cost_add = Ext.getCmp('txt' + depth + '_UCOST_ADD_H'); //보정단가                        

            var u_cost_total_original = Ext.getCmp('txt' + depth + '_UCOST_TOTAL');
            var u_cost_total = Ext.getCmp('txt' + depth + '_UCOST_TOTAL_H');

            var jang_original = Ext.getCmp('txt' + depth + '_JANG'); //장절        
            var jang = Ext.getCmp('txt' + depth + '_JANG_H'); //장절            

            var pok_original = Ext.getCmp('txt' + depth + '_POK'); //지폭
            var pok = Ext.getCmp('txt' + depth + '_POK_H'); //지폭

            var jaejok_original = Ext.getCmp('txt' + depth + '_JAEJOK'); //재적
            var jaejok = Ext.getCmp('txt' + depth + '_JAEJOK_H'); //재적

            var ingredient_ucost_original = Ext.getCmp('txt' + depth + '_INGREDIENT_UCOST'); //재료비            
            var ingredient_ucost = Ext.getCmp('txt' + depth + '_INGREDIENT_UCOST_H'); //재료비

            var apply_jipok = Ext.getCmp('txt' + depth + '_APPLY_JIPOK'); //지폭적용
            var material = Ext.getCmp('cbo' + depth + '_MATERIAL'); //재질
            var part_usage_unit = Ext.getCmp('cbo' + depth + '_PART_USAGE_UNIT'); //단위

            if (value == 'C/BOX') {

                jang_original.setValue(2 * (part_size_x.getValue() + part_size_y.getValue()));
                jang.setValue(2 * (part_size_x.getValue() + part_size_y.getValue()));

                pok_original.setValue((part_size_y.getValue() + part_size_z.getValue()));
                pok.setValue((part_size_y.getValue() + part_size_z.getValue()));

                var temp_jang;
                if (part_size_z.getValue() >= 200) {
                    if ((2 * part_size_x.getValue() + 2 * part_size_y.getValue()) < 2300) temp_jang = 45
                    else temp_jang = 90;
                } else {
                    if ((2 * part_size_x.getValue() + 2 * part_size_y.getValue()) < 2300) temp_jang = 75
                    else temp_jang = 90;
                }
                temp_jang = temp_jang + jang.getValue();

                var temp_pok;
                if (part_size_z.getValue() < 200) {
                    temp_pok = 39;
                } else temp_pok = 9;
                temp_pok = temp_pok + pok.getValue();

                jaejok_original.setValue(roundXL(temp_jang * temp_pok / 1000000, 2));
                jaejok.setValue(roundXL(temp_jang * temp_pok / 1000000, 2));


                u_cost.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());

            }
            else if (value == 'C/PAD') {
                jaejok_original.setValue(part_size_x.getValue() * part_size_y.getValue() / 1000000);
                jaejok.setValue(part_size_x.getValue() * part_size_y.getValue() / 1000000);

                u_cost_original.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가
                u_cost.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                //alert(us.getValue() +","+ u_cost_total.getValue());
                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());

            }
            else if (value == 'PE SHEET') {
                jaejok_original.setValue((part_size_x.getValue() * 1.08) * (part_size_y.getValue() * 1.08) * part_size_z.getValue() / 1000000);
                jaejok.setValue((part_size_x.getValue() * 1.08) * (part_size_y.getValue() * 1.08) * part_size_z.getValue() / 1000000);

                u_cost_original.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가
                u_cost.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가 

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());
            }
            else if (value == 'PE BAG') {
                jaejok_original.setValue((part_size_x.getValue() * 1.08) * (part_size_y.getValue() * 1.08) * part_size_z.getValue() / 1000000);
                jaejok.setValue((part_size_x.getValue() * 1.08) * (part_size_y.getValue() * 1.08) * part_size_z.getValue() / 1000000);

                u_cost_original.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가
                u_cost.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());

            }
            else if (value == 'VINYL BAG') {
                jaejok_original.setValue((part_size_x.getValue() * part_size_y.getValue() * part_size_z.getValue() * 0.921) / 1000000);
                jaejok.setValue((part_size_x.getValue() * part_size_y.getValue() * part_size_z.getValue() * 0.921) / 1000000);

                u_cost_original.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가
                u_cost.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가     

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());

            }
            else if (value == '격자 2 (세로)') {

                jaejok_original.setValue((part_size_x.getValue() + 30) * (part_size_y.getValue() + 30) / 1000000);
                jaejok.setValue((part_size_x.getValue() + 30) * (part_size_y.getValue() + 30) / 1000000);

                u_cost_original.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가
                u_cost.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가     

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());

            }
            else if (value == '격자 1 (가로)') {

                jaejok_original.setValue((part_size_x.getValue() + 30) * (part_size_y.getValue() + 30) / 1000000);
                jaejok.setValue((part_size_x.getValue() + 30) * (part_size_y.getValue() + 30) / 1000000);

                u_cost_original.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가
                u_cost.setValue(jaejok.getValue() * material_ucost.getValue()); //원단가                

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());

            }
            else if (value == 'OPP TAPE') {
                //alert(us.getValue() + "," + material_ucost.getValue());
                ingredient_ucost_original.setValue(us.getValue() * material_ucost.getValue());
                ingredient_ucost.setValue(us.getValue() * material_ucost.getValue());
            }
            else if (value == '부품식별표') {

                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());
            }
            else {

                if (part_usage_unit.getValue() != '' && part_usage_unit.getValue() == 'M') {
                    ingredient_ucost_original.setValue(us.getValue() * material_ucost.getValue());
                    ingredient_ucost.setValue(us.getValue() * material_ucost.getValue());
                } else if (part_usage_unit.getValue() != '' && part_usage_unit.getValue() != 'M') {

                    u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                    u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가

                    ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
                    ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());
                }
            }

            //            if (value == 'OPP TAPE') {                                    
            //                ingredient_ucost_original.setValue(us.getValue() * material_ucost.getValue());
            //                ingredient_ucost.setValue(us.getValue() * material_ucost.getValue());
            //            }
            //            else {                
            //                u_cost_total_original.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
            //                u_cost_total.setValue(u_cost_add.getValue() + u_cost.getValue()); //총단가
            //                
            //                ingredient_ucost_original.setValue(us.getValue() * u_cost_total.getValue());
            //                ingredient_ucost.setValue(us.getValue() * u_cost_total.getValue());
            //            }

            sum_material(); //재료비 합계    
        }

        function fn_top_change() {
            //            //IF(AG8 = "사출표면처리품", ROUNDDOWN((Y8 - 20) / (V8 + 13), 0), ROUNDDOWN((Y8 - 20) / (V8), 0))
            //            App.txt01_LOAD_X.setValue(Math.floor((App.txt01_TOP_MID_X.getValue() - 20) / (App.txt01_TOP_PART_X.getValue() + 13)));

            //            //= IF(AG8="사출표면처리품",ROUNDDOWN((Z8-20)/(W8+13),0),ROUNDDOWN((Z8-20)/(W8),0))
            //            App.txt01_LOAD_Y.setValue(Math.floor((App.txt01_TOP_MID_Y.getValue() - 20) / (App.txt01_TOP_PART_Y.getValue() + 13)));

            //            //=IF(AG8="사출표면처리품",ROUNDDOWN((AA8-20)/(X8+8),0),ROUNDDOWN((AA8-20)/(X8),0))
            //            App.txt01_LOAD_Z.setValue(Math.floor((App.txt01_TOP_MID_Z.getValue() - 20) / (App.txt01_TOP_PART_Z.getValue() + 8)));

            if (App.cbo01_PART_DIV.getValue() == '사출표면처리폼') {
                App.txt01_LOAD_X.setValue(Math.floor((App.txt01_TOP_MID_X.getValue() - 20) / (App.txt01_TOP_PART_X.getValue() + 13)));
                App.txt01_LOAD_Y.setValue(Math.floor((App.txt01_TOP_MID_Y.getValue() - 20) / (App.txt01_TOP_PART_Y.getValue() + 13)));
                App.txt01_LOAD_Z.setValue(Math.floor((App.txt01_TOP_MID_Z.getValue() - 20) / (App.txt01_TOP_PART_Z.getValue() + 8)));
            } else //외관
            {
                App.txt01_LOAD_X.setValue(Math.floor((App.txt01_TOP_MID_X.getValue() - 20) / App.txt01_TOP_PART_X.getValue()));
                App.txt01_LOAD_Y.setValue(Math.floor((App.txt01_TOP_MID_Y.getValue() - 20) / App.txt01_TOP_PART_Y.getValue()));
                App.txt01_LOAD_Z.setValue(Math.floor((App.txt01_TOP_MID_Z.getValue() - 20) / App.txt01_TOP_PART_Z.getValue()));
            }

            fn_top_change_load()
            //all_calculation('L');

        }

        //상단의 자동식에서 적입율 부분 수정 x, y, z
        function fn_top_change_load() {
            App.txt01_LOAD_TOTAL.setValue(App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() * App.txt01_LOAD_Z.getValue());
            all_calculation('L');
        }
        //전체 재 계산한다.
        // T :전체, L : 적입수량 변경시
        function all_calculation(value) {
            //for(var i =1; i < 14; i++)
            for (var i = 1; i < 15; i++) {

                var index = '';
                if (i < 10) index = '0';

                if (Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() != null && Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() != '') {
                    if (value != 'T') {
                        //아래의 두가지의 경우에 적입수량의 영향을 받는다.
                        if (Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == 'PE BAG' || Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == 'VINYL BAG') {
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_X').setValue((Math.ceil((App.txt01_TOP_PART_X.getValue() + (App.txt01_TOP_PART_Z.getValue() / 2)) / 10) * 10) * 2);
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_Y').setValue((Math.ceil((App.txt01_TOP_PART_Y.getValue() + (App.txt01_TOP_PART_Z.getValue() / 2)) / 10) * 10) * 2);
                            Ext.getCmp('txt' + index + i + '_PART_USAGE').setValue(App.txt01_LOAD_QTY.getValue());
                        }
                        else if (Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == 'C/BOX') {
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_X').setValue(App.txt01_TOP_MID_X.getValue());
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_Y').setValue(App.txt01_TOP_MID_Y.getValue());
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_Z').setValue(App.txt01_TOP_MID_Z.getValue());
                        }
                        else if (Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == 'C/PAD' || Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == 'PE SHEET') {
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_X').setValue(App.txt01_TOP_MID_X.getValue() - 20);
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_Y').setValue(App.txt01_TOP_MID_Y.getValue() - 20);
                            Ext.getCmp('txt' + index + i + '_PART_USAGE').setValue(App.txt01_LOAD_Z.getValue() + 1);
                        }
                        else if (Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == '격자 2 (세로)') {
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_X').setValue(App.txt01_TOP_MID_X.getValue() - 20);
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_Y').setValue(Math.floor((((App.txt01_TOP_MID_Z.getValue() - 30) - ((App.txt01_LOAD_Z.getValue() + 1) * 3)) / App.txt01_LOAD_Z.getValue())));
                            Ext.getCmp('txt' + index + i + '_PART_USAGE').setValue((App.txt01_LOAD_Y.getValue() + 1) * App.txt01_LOAD_Z.getValue());
                        }
                        else if (Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == '격자 1 (가로)') {
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_X').setValue(App.txt01_TOP_MID_Y.getValue() - 20);
                            Ext.getCmp('txt' + index + i + '_PART_SIZE_Y').setValue(Math.floor((((App.txt01_TOP_MID_Z.getValue() - 30) - ((App.txt01_LOAD_Z.getValue() + 1) * 3)) / App.txt01_LOAD_Z.getValue())));
                            Ext.getCmp('txt' + index + i + '_PART_USAGE').setValue((App.txt01_LOAD_X.getValue() + 1) * App.txt01_LOAD_Z.getValue());
                        }
                        else if (Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue() == 'OPP TAPE') {
                            Ext.getCmp('txt' + index + i + '_PART_USAGE').setValue((App.txt01_TOP_MID_X.getValue() + 100) / 1000 * 2);
                        }

                    }

                    Calc('', index + i, Ext.getCmp('cbo' + index + i + '_PACK_MATERIAL').getValue(), false);

                }
            }

            for (var i = 1; i < 7; i++) {
                if (Ext.getCmp('cbo0' + i + '_PROC').getValue() != null && Ext.getCmp('cbo0' + i + '_PROC').getValue() != '') {
                    if (value != 'T') {
                        var temp_ctime = 0;
                        //아래의 경우에 적입수량의 영향을 받는다.                        
                        if (Ext.getCmp('cbo0' + i + '_PROC').getValue() == '제품적입') {

                            Ext.getCmp('txt0' + i + '_CV').setValue(App.txt01_LOAD_QTY.getValue());
                            Ext.getCmp('txt0' + i + '_CV_H').setValue(App.txt01_LOAD_QTY.getValue());

                            if (App.cbo01_PART_DIV.getValue() == '사출표면처리폼') {
                                temp_ctime = 10;
                            } else {
                                if (App.txt01_LOAD_QTY.getValue() >= 300) temp_ctime = 1;
                                else temp_ctime = 2;

                            }
                            Ext.getCmp('cbo0' + i + '_CTIME_H').setValue(temp_ctime);
                        }
                        else if (Ext.getCmp('cbo0' + i + '_PROC').getValue() == '격자조립') {

                            if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 4) temp_ctime = 20;
                            else if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 6) temp_ctime = 30;
                            else if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 10) temp_ctime = 35;
                            else if (App.txt01_LOAD_X.getValue() * App.txt01_LOAD_Y.getValue() <= 15) temp_ctime = 40;
                            else temp_ctime = 70;

                            Ext.getCmp('txt0' + i + '_CV').setValue(App.txt01_LOAD_Z.getValue());
                            Ext.getCmp('txt0' + i + '_CV_H').setValue(App.txt01_LOAD_Z.getValue());
                            Ext.getCmp('cbo0' + i + '_CTIME_H').setValue(temp_ctime);
                        }
                    }
                    CalcProc('', '0' + i, Ext.getCmp('cbo0' + i + '_PROC').getValue(), false);
                }

            }
        }

        //재료비 합산
        function sum_material() {
            var sum_val = 0;
            for (var i = 1; i < 15; i++) {
                if (i < 10) {
                    sum_val += Ext.getCmp('txt' + '0' + i + '_INGREDIENT_UCOST_H').getValue();
                }
                else {
                    sum_val += Ext.getCmp('txt' + i + '_INGREDIENT_UCOST_H').getValue(); ;
                }
            }
            sum_val = Math.floor(sum_val);

            App.txt01_MATERIAL_SUM.setValue(sum_val);
            App.txt01_MATERIAL_SUM_H.setValue(sum_val);
            TotalSum();
        }

        function TotalSum() {
            App.txt01_BASIC_COST_H.setValue(App.txt01_MANUFATUR_SUM_H.getValue() * 0.15);
            App.txt01_BASIC_COST.setValue(App.txt01_MANUFATUR_SUM_H.getValue() * 0.15);

            App.txt01_PROFIT_H.setValue((App.txt01_MANUFATUR_SUM_H.getValue() + App.txt01_BASIC_COST_H.getValue()) * 0.1);
            App.txt01_PROFIT.setValue((App.txt01_MANUFATUR_SUM_H.getValue() + App.txt01_BASIC_COST_H.getValue()) * 0.1);

            App.txt01_MATERIAL_MANAGE_COST_H.setValue(App.txt01_MATERIAL_SUM_H.getValue() * 0.05);
            App.txt01_MATERIAL_MANAGE_COST.setValue(App.txt01_MATERIAL_SUM_H.getValue() * 0.05);

            App.txt01_PACKING_TOTAL.setValue(Math.floor(App.txt01_MATERIAL_SUM_H.getValue() + App.txt01_MANUFATUR_SUM_H.getValue() + App.txt01_BASIC_COST_H.getValue() + App.txt01_PROFIT_H.getValue() + App.txt01_MATERIAL_MANAGE_COST_H.getValue() +
                                                App.txt01_PROC_HEAT_H.getValue() + App.txt01_STUFF_CHARGE_H.getValue() + App.txt01_USE_MACHINE_H.getValue() + App.txt01_MOLD_COST_H.getValue()));

            App.txt01_PACKING_TOTAL_H.setValue(Math.floor(App.txt01_MATERIAL_SUM_H.getValue() + App.txt01_MANUFATUR_SUM_H.getValue() + App.txt01_BASIC_COST_H.getValue() + App.txt01_PROFIT_H.getValue() + App.txt01_MATERIAL_MANAGE_COST_H.getValue() +
                                                App.txt01_PROC_HEAT_H.getValue() + App.txt01_STUFF_CHARGE_H.getValue() + App.txt01_USE_MACHINE_H.getValue() + App.txt01_MOLD_COST_H.getValue()));

            App.txt01_CHECK_BOXCOST_H.setValue(App.txt01_PACKING_TOTAL_H.getValue());
            App.txt01_CHECK_BOXCOST.setValue(App.txt01_PACKING_TOTAL_H.getValue());

            App.txt01_DECIDED_BOXCOST_H.setValue(App.txt01_CHECK_BOXCOST_H.getValue());
            App.txt01_DECIDED_BOXCOST.setValue(App.txt01_CHECK_BOXCOST_H.getValue());

            var check_value = 0;
            if (App.txt01_LOAD_QTY.getValue() != 0) check_value = Math.floor(App.txt01_CHECK_BOXCOST_H.getValue() / App.txt01_LOAD_QTY.getValue());


            App.txt01_CHECK_EACOST_H.setValue(check_value);
            App.txt01_CHECK_EACOST.setValue(check_value);

            App.txt01_DECIDED_EACOST_H.setValue(App.txt01_CHECK_EACOST_H.getValue());
            App.txt01_DECIDED_EACOST.setValue(App.txt01_CHECK_EACOST_H.getValue());

        }

        function RemoveCls(id) {
            var cmp = Ext.getCmp(id);
            cmp.removeCls('changeColorYellow');
        }

        function setLoad_qty(value) {
            App.txt01_LOAD_QTY.setValue(value);
            all_calculation('L');
        }

        var PrintReport = function (btn) {
            if (btn == "yes")
                App.direct.Print();
        }

    </script>
</head>
<body>
    <form id="SRM_PS20002P1" runat="server">
    <ext:ResourceManager ID="ResourceManager1" runat="server">
        <Listeners>
            <DocumentReady Handler="ExtDocumentReady();" />
        </Listeners>
    </ext:ResourceManager>
    <%-- 4.X 신규추가;;; --%>
    <ext:Hidden ID="hid01_MODE" runat="server" />
    <%-- 숨겨 사용하기 ^^;;; --%>
    <ext:TextField ID="txt01_initCheck" runat="server" Hidden="true" /> 
    <ext:TextField ID="txt01_ID" runat="server" Hidden="true" />    
    <ext:TextField ID="CodeValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 code값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="NameValue" runat="server" Hidden="true"></ext:TextField> <%--팝업호출시 그리드의 Name값을 팝업에 넘기기 위해서 사용--%>
    <ext:TextField ID="CodeRow" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 row index--%>
    <ext:TextField ID="CodeCol" runat="server" Hidden="true"></ext:TextField> <%--팝업에서 값을 선택후에 그리드에서 선택된 cell에 값을 설정하기 위해서 사용하는 col index (사용하지 않으나 차후 필요할지 몰라서)--%>    

    <ext:Viewport ID="UIContainer" runat="server" Layout="BorderLayout" Padding="10">
        <Listeners>
            <Resize Fn="UI_Resize">
            </Resize>           
        </Listeners>
        <Items>
            <%--타이틀 및 공통버튼 영역--%>
            <ext:Panel ID="TitlePanel" Region="North" runat="server" Height="30">
                <Items>
                    <ext:Label ID="lbl01_SRM_VM20001" runat="server" Cls="search_area_title_name" Text="원 가 계 산 서"/>
                    <ext:Panel ID="ButtonPanel" runat="server"  StyleSpec="width:100%"  Height="30" Cls="search_area_title_btn">
                        <Items>
                            <%-- 상단 이미지버튼 --%>
                        </Items>
                    </ext:Panel>
                </Items>
            </ext:Panel>

            <%--입력 영역
            4.X에서 overflow:scroll -> auto, Scrollable추가, region 추가--%>
            <ext:Panel ID="InputPanel" runat="server" Width="1300" Height="2630"   Scrollable="Both" StyleSpec="overflow:auto;"  Region="Center">
                <Items>
                    <%--자동 계산입력양식--%>
                    <ext:Label ID="Label78" runat="server" Cls="bottom_area_title_name" Text="자동계산입력양식(제품사이즈, 중포장사이즈, 업체/제품 구분 입력 요망)" />
                    <ext:Panel ID="Panel5" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1100px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 80px;" />
                                    <col style="width: 80px;" />
                                    <col style="width: 80px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 100px;"/>                                    
                                    <col style="width: 100px;"/>
                                    <col />
                                </colgroup>
                                <tr>
                                    <th colspan="3"  class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label80" runat="server" Text="제품"/>
                                    </th>  
                                    <th colspan="3"  class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label82" runat="server" Text="중포장"/>
                                    </th>
                                    <th colspan="4"  class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label83" runat="server" Text="적입수량"/>
                                    </th>                                    
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label101" runat="server" Text="업체구분"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label103" runat="server" Text="제품구분"/>
                                    </th>  
                                </tr>
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label84" runat="server" Text="가로(mm)"/>
                                    </th>  
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label85" runat="server" Text="세로(mm)"/>
                                    </th>                                      
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label92" runat="server" Text="높이(mm)"/>
                                    </th>  
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label93" runat="server" Text="가로(mm)"/>
                                    </th>  
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label94" runat="server" Text="세로(mm)"/>
                                    </th>  
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label95" runat="server" Text="높이(mm)"/>
                                    </th>  
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label96" runat="server" Text="가로"/>
                                    </th>  
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label97" runat="server" Text="세로"/>
                                    </th>  
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label99" runat="server" Text="높이"/>
                                    </th>                                                                                                         
                                    <th class="line" style="text-align:center;vertical-align:middle;background-color:Yellow;">
                                        <ext:Label ID="Label91" runat="server" Text="합계"/>
                                    </th>  
                                </tr>                                                                      
                                <tr>
                                    <td class="line" style="text-align:center;height:30px;">
                                        <ext:NumberField ID="txt01_TOP_PART_X"  runat="server" Width="75" Cls="inputText_Num"  FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>    
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_TOP_PART_Y"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_TOP_PART_Z"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_TOP_MID_X"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_TOP_MID_Y"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_TOP_MID_Z"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="1" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_LOAD_X"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" >                               
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change_load();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_LOAD_Y"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" >                                      
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change_load();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_LOAD_Z"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" >                                  
                                            <Listeners>
                                                <KeyUp Handler="fn_top_change_load();"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_LOAD_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                     
                                            <Listeners>
                                                <Change Handler="setLoad_qty(this.getValue());"></Change>
                                            </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo01_VEND_DIV" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="95" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="1차사" Text="1차사" />
                                                <ext:ListItem Value="2차사" Text="2차사" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeImyul(this.getValue());"></Select>
                                            </Listeners>
                                        </ext:ComboBox>                                        
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo01_PART_DIV" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="200" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="사출표면처리폼" Text="사출표면처리폼" />
                                                <ext:ListItem Value="사출비외관폼" Text="사출비외관폼" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangPartDiv(this.getValue());"></Select>
                                            </Listeners>
                                         </ext:ComboBox> 
                                    </td>                                    
                                </tr>
                            </table>                            
                        </Content>                        
                    </ext:Panel>   

                    <%--1.일반정보--%>
                    <ext:Label ID="lbl01_TIT_GEN" runat="server" Cls="bottom_area_title_name" Text="기본정보" />
                    <ext:Panel ID="pnl01_GEN" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 70px;" />
                                    <col style="width: 200px;" />
                                    <col style="width: 150px;"/>
                                    <col style="width: 200px;"/>
                                    <col style="width: 150px;"/>
                                    <col />
                                </colgroup>
                                
                                <tr>
                                    <th>
                                        <ext:Label ID="lbl01_VINNM" runat="server" Text="차종" />
                                    </th>
                                    <td>
                                        <epc:EPCodeBox ID="cdx01_VINCD" runat="server" HelperID="HELP_TYPECD" PopupMode="Search" PopupType="CodeWindow" ClassID="A3" WidthTYPECD="80" WidthTYPENM="80" />
                                    </td>    
                                    <th>
                                        <ext:Label ID="lbl01_VENDNM" runat="server" Text="업 체 명"/>
                                    </th>  
                                    <td>
                                        <epc:EPCodeBox ID="cdx01_VENDCD" runat="server" HelperID="HELP_VENDCD" PopupMode="Search" PopupType="HelpWindow" WidthTYPECD="80" WidthTYPENM="80" />
                                    </td>
                                    <th>
                                        <ext:Label ID="lbl01_CUSTNM" runat="server" Text="해외 법인명"/>
                                    </th>  
                                    <td>
<%--                                        <ext:ComboBox ID="cbo01_CUSTCD" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="172" Editable="false">                                            
                                            <Items>                                                         
                                                <ext:ListItem Value="20000" Text="강소서연이화" />
                                                <ext:ListItem Value="20001" Text="북경서연" />
                                                <ext:ListItem Value="20003" Text="요녕서연이화" />
                                                <ext:ListItem Value="20004" Text="서연이화인디아" />
                                                <ext:ListItem Value="20005" Text="서연이화첸나이" />
                                                <ext:ListItem Value="20006" Text="서연이화슬로박" />
                                                <ext:ListItem Value="20007" Text="서연이화알라바마" />
                                                <ext:ListItem Value="20008" Text="서연이화조지아" />
                                                <ext:ListItem Value="20009" Text="서연이화브라질" />
                                                <ext:ListItem Value="20010" Text="앗싼한일" />
                                                <ext:ListItem Value="20393" Text="서연이화폴란드" />
                                                <ext:ListItem Value="20412" Text="서연이화멕시코" />
                                                <ext:ListItem Value="20732" Text="북기한일(창주)" />
                                                <ext:ListItem Value="20733" Text="북기한일(중경)" />
                                            </Items>
                                        </ext:ComboBox>--%>
                                        <ext:SelectBox ID="cbo01_CUSTCD" runat="server"  Mode="Local" ForceSelection="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="172" >
                                            <Store>
                                                <ext:Store ID="Store21" runat="server" >
                                                    <Model>
                                                        <ext:Model ID="Model21" runat="server">
                                                            <Fields>
                                                                <ext:ModelField Name="ID" />
                                                                <ext:ModelField Name="NAME" />
                                                            </Fields>
                                                        </ext:Model>
                                                    </Model>
                                                </ext:Store>
                                            </Store>
                                        </ext:SelectBox> 
                                    </td>
                                </tr>        
                                <tr>
                                    <th>
                                        <ext:Label ID="lbl01_PARTNO" runat="server" Text="품번"  ReadOnly="true" />
                                    </th>
                                    <td colspan="3">
                                        <ext:FieldContainer ID="FieldContainer18" runat="server" Width="540" Flex="1" MsgTarget="Side" Layout="TableLayout">
                                            <Items> 
                                                <ext:TextField ID="txt01_PARTNO"  runat="server" Width="460" Cls="inputText"  ReadOnly="false" >                                                    
                                                </ext:TextField>
                                                <ext:Button ID="btn01_PACKINFO" runat="server" TextAlign="Center" Text="확인하기" >                                                
                                                    <DirectEvents>                                                        
                                                       <Click OnEvent="etc_Button_Click" > 
                                                            <Confirmation ConfirmRequest="true" Title="Confirm" Message="확인 하시면 재료비, 가공비 재계산됩니다." />
                                                       </Click>
                                                    </DirectEvents>
                                                </ext:Button>  
                                            </Items>
                                        </ext:FieldContainer>  
                                    </td>                                        
                                    <th>
                                        <ext:Label ID="lbl01_LOAD_QTY" runat="server" Text="적 입 수 량"/>
                                    </th>  
                                    <td>                                        
                                        <ext:NumberField ID="txt01_LOAD_QTY"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" HideTrigger="true" EnableKeyEvents="true">   
                                            <Listeners>
                                                <KeyUp Handler="all_calculation('L');"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <ext:Label ID="lbl01_PARTNM" runat="server" Text="품명" />
                                    </th>
                                    <td colspan="3">
                                        <ext:TextField ID="txt01_PARTNM"  runat="server" Width="540" Cls="inputText"  ReadOnly="false" />
                                    </td>                                        
                                    <th>
                                        <ext:Label ID="lbl01_TYPE_STANDARD" runat="server" Text="중포장코드"/>
                                    </th>  
                                    <td>  
                                        <ext:TextField ID="txt01_TYPE"  runat="server" Width="172" Cls="inputText"  ReadOnly="false" />                                                                             
                                    </td>
                                </tr>                                
                            </table>
                        </Content>
                    </ext:Panel>

                    <%--2.재료비--%>
                    <ext:Label ID="Label1" runat="server" Cls="bottom_area_title_name" Text="재료비" />
                    <ext:Panel ID="Panel1" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 70px;" />
                                    <col style="width: 115px;" />
                                    <col style="width: 155px;" />
                                    <col style="width: 40px;" />
                                    <col style="width: 50px;" />
                                    <col style="width: 50px;" />
                                    <col style="width: 50px;" />
                                    <col style="width: 50px;" />
                                    <col style="width: 70px;" />
                                    <col style="width: 70px;" />
                                    <col style="width: 70px;" />
                                    <col style="width: 70px;" />
                                    <col style="width: 70px;" />
                                    <col style="width: 70px;" />
                                    <col style="width: 80px;" />
                                    <col />
                                </colgroup>
                                
                                <tr style="height:3px;">
                                    <th rowspan="18" class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label2" runat="server" Text="재" /><br /><br /><br /><br />
                                        <ext:Label ID="Label20" runat="server" Text="료" /><br /><br /><br /><br />
                                        <ext:Label ID="Label21" runat="server" Text="비" />
                                    </th>
                                    <th rowspan="2" class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label9" runat="server" Text="부 품 명"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label3" runat="server" Text="규격(mm)"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label4" runat="server" Text="US"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label10" runat="server" Text="단위"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label11" runat="server" Text="원단가"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label75" runat="server" Text="보정"/><br />
                                        <ext:Label ID="Label98" runat="server" Text="단가"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label76" runat="server" Text="총단가"/>
                                    </th>  
                                    <th colspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label12" runat="server" Text="제품(NET)"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label13" runat="server" Text="지폭"/><br />
                                        <ext:Label ID="Label8" runat="server" Text="적용"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label14" runat="server" Text="재적"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label15" runat="server" Text="재질"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label16" runat="server" Text="재질"/><br />
                                        <ext:Label ID="Label18" runat="server" Text="단가"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label17" runat="server" Text="재료비"/><br />
                                        <ext:Label ID="Label7" runat="server" Text="(USx단가)"/>
                                    </th>                  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label77" runat="server" Text="비고"/>
                                    </th>                                                          
                                </tr>      
                                <tr style="height:3px;">
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label5" runat="server" Text="장절"/></th>
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label6" runat="server" Text="폭절"/></th>                                                              
                                </tr>
                                <tr style="height:1px;">
                                    <td class="line" style="text-align:center;"></td>                                    
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>
                                    <td class="line" style="text-align:center;"></td>      
                                    <td class="line" style="text-align:center;"></td> 
                                    <td class="line" style="text-align:center;"></td> 
                                </tr>
                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo01_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer6" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('01',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label79" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt01_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('01',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label81" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt01_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('01',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;" id="lbl01_PART_USAGE">
                                        <ext:NumberField ID="txt01_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('01',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo01_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt01_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt01_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt01_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt01_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt01_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt01_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo01_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'01');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo01_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store5" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model5" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt01_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '01', App.cbo01_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt01_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo02_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer1" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt02_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('02',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label52" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt02_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('02',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label66" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt02_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('02',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('02',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo02_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt02_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt02_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt02_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt02_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt02_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt02_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo02_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'02');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo02_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store1" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model1" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt02_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '02', App.cbo02_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt02_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo03_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer2" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt03_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('03',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label100" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt03_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('03',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label102" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt03_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('03',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('03',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo03_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt03_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt03_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt03_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt03_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt03_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt03_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo03_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'03');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo03_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store2" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model2" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt03_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '03', App.cbo03_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt03_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo04_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer3" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt04_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('04',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label104" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt04_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('04',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label105" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt04_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('04',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('04',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo04_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt04_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt04_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt04_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt04_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt04_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt04_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo04_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'04');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo04_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store3" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model3" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt04_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '04', App.cbo04_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt04_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo05_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer4" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt05_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('05',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label106" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt05_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('05',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label107" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt05_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('05',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('05',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo05_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt05_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt05_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt05_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt05_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt05_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt05_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo05_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'05');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo05_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store4" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model4" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt05_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '05', App.cbo05_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt05_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo06_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer5" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt06_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('06',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label108" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt06_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('06',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label109" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt06_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('06',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('06',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo06_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt06_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt06_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt06_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt06_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt06_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt06_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo06_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'06');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo06_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store6" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model6" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt06_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '06', App.cbo06_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt06_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo07_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer7" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt07_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('07',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label110" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt07_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('07',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label111" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt07_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('07',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt07_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('07',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo07_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt07_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt07_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt07_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt07_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt07_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt07_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt07_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt07_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt07_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt07_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt07_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt07_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt07_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt07_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt07_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt07_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt07_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt07_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt07_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo07_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'07');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo07_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store7" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model7" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt07_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '07', App.cbo07_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt07_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt07_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt07_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo08_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer8" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt08_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('08',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label112" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt08_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('08',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label113" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt08_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('08',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt08_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('08',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo08_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt08_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt08_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt08_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt08_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt08_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt08_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt08_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt08_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt08_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt08_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt08_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt08_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt08_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt08_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt08_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt08_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt08_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt08_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt08_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo08_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'08');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo08_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store8" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model8" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt08_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '08', App.cbo08_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt08_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt08_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt08_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo09_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer9" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt09_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('09',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label114" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt09_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('09',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label115" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt09_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('09',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt09_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('09',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo09_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt09_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt09_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt09_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt09_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt09_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt09_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt09_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt09_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt09_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt09_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt09_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt09_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt09_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt09_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt09_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt09_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt09_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt09_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt09_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo09_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'09');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo09_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store9" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model9" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt09_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '09', App.cbo09_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt09_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt09_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt09_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo10_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer10" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt10_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('10',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label116" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt10_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('10',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label117" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt10_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('10',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt10_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('10',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo10_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt10_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt10_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt10_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt10_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt10_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt10_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt10_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt10_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt10_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt10_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt10_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt10_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt10_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt10_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt10_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt10_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt10_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt10_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt10_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo10_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'10');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo10_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store10" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model10" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt10_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '10', App.cbo10_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt10_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt10_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt10_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo11_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer11" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt11_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('11',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label118" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt11_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('11',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label119" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt11_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('11',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt11_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('11',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo11_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt11_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt11_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt11_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt11_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt11_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt11_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt11_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt11_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt11_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt11_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt11_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt11_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt11_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt11_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt11_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt11_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt11_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt11_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt11_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo11_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'11');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo11_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store11" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model11" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt11_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '11', App.cbo11_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt11_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt11_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt11_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo12_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer12" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt12_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('12',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label120" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt12_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('12',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label121" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt12_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('12',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt12_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('12',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo12_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt12_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt12_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt12_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt12_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt12_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt12_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt12_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt12_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt12_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt12_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt12_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt12_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt12_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt12_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt12_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt12_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt12_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt12_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt12_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo12_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'12');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo12_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store12" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model12" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt12_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '12', App.cbo12_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt12_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt12_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt12_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo13_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer13" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt13_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('13',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label122" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt13_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('13',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label123" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt13_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('13',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt13_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('13',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo13_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt13_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt13_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt13_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt13_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt13_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt13_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt13_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt13_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt13_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt13_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt13_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt13_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt13_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt13_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt13_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt13_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt13_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt13_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt13_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo13_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'13');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo13_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store13" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model13" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt13_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '13', App.cbo13_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt13_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt13_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt13_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo14_PACK_MATERIAL" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="110">
                                            <Items>                                                
                                                <ext:ListItem Value="C/BOX" Text="C/BOX" />
                                                <ext:ListItem Value="C/PAD" Text="C/PAD" />
                                                <ext:ListItem Value="격자 1 (가로)" Text="격자 1 (가로)" />
                                                <ext:ListItem Value="격자 2 (세로)" Text="격자 2 (세로)" />
                                                <ext:ListItem Value="VINYL BAG" Text="VINYL BAG" />
                                                <ext:ListItem Value="PE BAG" Text="PE BAG" />
                                                <ext:ListItem Value="PE SHEET" Text="PE SHEET" />
                                                <ext:ListItem Value="방습제" Text="방습제" />
                                                <ext:ListItem Value="방습 VINYL" Text="방습 VINYL" />
                                                <ext:ListItem Value="TRAY" Text="TRAY" /> 
                                                <ext:ListItem Value="OPP TAPE" Text="OPP TAPE" />                         
                                                <ext:ListItem Value="부품식별표" Text="부품식별표" />   
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeMaterial(this, true);"></Select>
                                                <Change Handler="ChangeMaterial(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                      <ext:FieldContainer ID="FieldContainer14" runat="server" MsgTarget="Side" Flex="1" Width="155" Layout="TableLayout">
                                            <Items>                                        
                                            <ext:NumberField ID="txt14_PART_SIZE_X"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>                                                    
                                                    <KeyUp Handler="fn_top_hidden_change('14',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label124" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt14_PART_SIZE_Y"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('14',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                            
                                            <ext:Label ID="Label125" runat="server" Text="X" Padding="2"/>
                                            <ext:NumberField ID="txt14_PART_SIZE_Z"  runat="server" Width="40" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="fn_top_hidden_change('14',false);"></KeyUp>
                                                </Listeners>
                                            </ext:NumberField>                                               
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt14_PART_USAGE"  runat="server" Width="35" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">                                       
                                            <Listeners>
                                                <KeyUp Handler="fn_top_hidden_change('14',false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                            <ext:ComboBox ID="cbo14_PART_USAGE_UNIT" runat="server"  Mode="Local" 
                                                TriggerAction="All" Width="45" Editable="false" PaddingSpec="0px 0px 0px 0px" >
                                                <Items>                                                
                                                    <ext:ListItem Value="EA" Text="EA" />
                                                    <ext:ListItem Value="RL" Text="RL" />
                                                    <ext:ListItem Value="KG" Text="KG" />
                                                    <ext:ListItem Value="SH" Text="SH" />
                                                    <ext:ListItem Value="M" Text="M" />
                                                </Items>
                                            </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt14_UCOST_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt14_UCOST"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt14_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt14_UCOST_ADD_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt14_UCOST_ADD"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt14_UCOST_ADD_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt14_UCOST_TOTAL_H" Hidden="true"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt14_UCOST_TOTAL"  runat="server" Width="45" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt14_UCOST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:NumberField ID="txt14_JANG_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt14_JANG"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt14_JANG_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt14_POK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt14_POK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt14_POK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt14_APPLY_JIPOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true"/>
                                    </td>
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt14_JAEJOK_H" Hidden="true"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt14_JAEJOK"  runat="server" Width="65" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt14_JAEJOK_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField> 
                                    </td>      
                                    <td class="line" style="text-align:center;">                                                                                
                                        <ext:ComboBox ID="cbo14_MATERIAL" runat="server"  Mode="Local" 
                                            TriggerAction="All" Width="65" Editable="false" >
                                            <Items>                                                         
                                                <ext:ListItem Value="DW3" Text="DW3" />
                                                <ext:ListItem Value="SW3" Text="SW3" />                                                
                                            </Items>             
                                            <Listeners>
                                                <Select Handler="changeMaterialUcost(this.getValue(),'14');"></Select>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>                                    
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:ComboBox ID="cbo14_MATERIAL_UCOST_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="65" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store14" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model14" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Select>--%>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>      
                                    <td class="line" style="text-align:center;">                                        
                                        <ext:NumberField ID="txt14_INGREDIENT_UCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="Calc(this.getId(), '14', App.cbo14_PACK_MATERIAL.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt14_INGREDIENT_UCOST"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt14_INGREDIENT_UCOST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td> 
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt14_REMARK"  runat="server" Width="200" Cls="inputText"  ReadOnly="false" />
                                    </td> 
                                </tr>
 
                                <tr style="height:3px;">
                                    <th colspan="12" class="line" style="text-align:center;font-weight:bold;vertical-align:middle;font-size:15px;">
                                        <ext:Label ID="Label19" runat="server" Text="①재 료 비 소 계"/>
                                    </th>
                                    <td colspan="3" class="line" style="text-align:right;font-weight:bold;vertical-align:middle;font-size:15px;">
                                        <ext:NumberField ID="txt01_MATERIAL_SUM_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_MATERIAL_SUM"  runat="server" Width="358" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                                                 
                                </tr>
                            </table>
                        </Content>
                    </ext:Panel>     
                    <%--3.가공비--%>
                    <ext:Label ID="Label22" runat="server" Cls="bottom_area_title_name" Text="가공비" />
                    <ext:Panel ID="Panel2" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 70px;" />
                                    <col style="width: 180px;" />
                                    <col style="width: 230px;"/>
                                    <col style="width: 130px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 100px;"/>
                                    <col style="width: 100px;"/>
                                    <col style="width: 130px;"/>
                                    <col style="width: 100px;"/>
                                    <col style="width: 100px;"/>
                                    <col style="width: 100px;"/>
                                    
                                    <col />                                    
                                </colgroup>
                                
                                <tr style="height:30px;">
                                    <th rowspan="18" class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label23" runat="server" Text="가" /><br /><br />
                                        <ext:Label ID="Label24" runat="server" Text="공" /><br /><br />
                                        <ext:Label ID="Label25" runat="server" Text="비" />
                                    </th>
                                    <th rowspan="2" class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label26" runat="server" Text="부 품 명"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label27" runat="server" Text="공 정 명"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label28" runat="server" Text="C/TIME"/>
                                    </th>  
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label29" runat="server" Text="C/V"/>
                                    </th>  
                                    <th colspan="3"class="line" style="text-align:center;vertical-align:middle;font-size:15px;font-weight:bold;">
                                        <ext:Label ID="Label30" runat="server" Text="노 무 비②"/>
                                    </th>  
                                    <th colspan="3"class="line" style="text-align:center;vertical-align:middle;font-size:15px;font-weight:bold;">
                                        <ext:Label ID="Label31" runat="server" Text="경    비③"/>
                                    </th>                                      
                                    <th rowspan="2"class="line" style="text-align:center;vertical-align:middle;">
                                        <span style="font-weight:bold;"><ext:Label ID="Label38" runat="server" Text="가공비"/></span><br />
                                        <ext:Label ID="Label39" runat="server" Text="(노무비+경비)"/>
                                    </th>                                      
                                </tr>      
                                <tr>
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label40" runat="server" Text="인원"/></th>
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label41" runat="server" Text="임율"/></th>
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label32" runat="server" Text="금 액"/></th>
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label33" runat="server" Text="기계명"/></th>
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label34" runat="server" Text="기계경비"/></th>
                                    <th class="line" style="text-align:center;"><ext:Label ID="Label35" runat="server" Text="금 액"/></th>
                                </tr>
                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">
                                    </td>                                    
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo01_PROC" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="225">
                                            <Items>                                                
                                                <ext:ListItem Value="BOX조립" Text="BOX조립" />
                                                <ext:ListItem Value="제품적입" Text="제품적입" />
                                                <ext:ListItem Value="격자조립" Text="격자조립" />
                                                <ext:ListItem Value="마무리" Text="마무리" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeProcess(this, true);"></Select>
                                                <Change Handler="ChangeProcess(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo01_CTIME_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="120" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store15" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model15" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_CV_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_CV"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_CV_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_MAN_QTY" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_IMYUL" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_MAN_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_MAN_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_MAN_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt01_MACHINE_NM"  runat="server" Width="95" Cls="inputText"  ReadOnly="false" />
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_MACHINE_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_MACHINE_COST"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_MACHINE_COST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt01_MACHINE_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_MACHINE_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_MACHINE_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:right;">
                                        <ext:NumberField ID="txt01_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '01', App.cbo01_PROC.getValue(), false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_COST_TOTAL"  runat="server" Width="125" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>                                  
                                </tr>

                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">
                                    </td>                                    
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo02_PROC" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="225">
                                            <Items>                                                
                                                <ext:ListItem Value="BOX조립" Text="BOX조립" />
                                                <ext:ListItem Value="제품적입" Text="제품적입" />
                                                <ext:ListItem Value="격자조립" Text="격자조립" />
                                                <ext:ListItem Value="마무리" Text="마무리" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeProcess(this, true);"></Select>
                                                <Change Handler="ChangeProcess(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo02_CTIME_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="120" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store16" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model16" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="CalcProc(this.getId(), '02', App.cbo01_PROC.getValue(), false);"></Select>--%>
                                                <Change Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>  
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_CV_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_CV"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_CV_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_MAN_QTY" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_IMYUL" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_MAN_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_MAN_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_MAN_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt02_MACHINE_NM"  runat="server" Width="95" Cls="inputText"  ReadOnly="false" />
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_MACHINE_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_MACHINE_COST"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_MACHINE_COST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt02_MACHINE_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_MACHINE_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_MACHINE_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:right;">
                                        <ext:NumberField ID="txt02_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '02', App.cbo02_PROC.getValue(), false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt02_COST_TOTAL"  runat="server" Width="125" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt02_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>                                  
                                </tr>
                                     
                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">
                                    </td>                                    
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo03_PROC" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="225">
                                            <Items>                                                
                                                <ext:ListItem Value="BOX조립" Text="BOX조립" />
                                                <ext:ListItem Value="제품적입" Text="제품적입" />
                                                <ext:ListItem Value="격자조립" Text="격자조립" />
                                                <ext:ListItem Value="마무리" Text="마무리" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeProcess(this, true);"></Select>
                                                <Change Handler="ChangeProcess(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo03_CTIME_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="120" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store17" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model17" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="CalcProc(this.getId(), '03', App.cbo01_PROC.getValue(), false);"></Select>--%>
                                                <Change Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_CV_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_CV"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_CV_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_MAN_QTY" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_IMYUL" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_MAN_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_MAN_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_MAN_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt03_MACHINE_NM"  runat="server" Width="95" Cls="inputText"  ReadOnly="false" />
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_MACHINE_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_MACHINE_COST"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_MACHINE_COST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt03_MACHINE_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_MACHINE_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_MACHINE_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:right;">
                                        <ext:NumberField ID="txt03_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '03', App.cbo03_PROC.getValue(), false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt03_COST_TOTAL"  runat="server" Width="125" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt03_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>                                  
                                </tr>
                                        
                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">
                                    </td>                                    
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo04_PROC" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="225">
                                            <Items>                                                
                                                <ext:ListItem Value="BOX조립" Text="BOX조립" />
                                                <ext:ListItem Value="제품적입" Text="제품적입" />
                                                <ext:ListItem Value="격자조립" Text="격자조립" />
                                                <ext:ListItem Value="마무리" Text="마무리" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeProcess(this, true);"></Select>
                                                <Change Handler="ChangeProcess(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo04_CTIME_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="120" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store18" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model18" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="CalcProc(this.getId(), '04', App.cbo01_PROC.getValue(), false);"></Select>--%>
                                                <Change Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_CV_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_CV"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_CV_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_MAN_QTY" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_IMYUL" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_MAN_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_MAN_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_MAN_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt04_MACHINE_NM"  runat="server" Width="95" Cls="inputText"  ReadOnly="false" />
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_MACHINE_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_MACHINE_COST"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_MACHINE_COST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt04_MACHINE_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_MACHINE_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_MACHINE_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:right;">
                                        <ext:NumberField ID="txt04_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '04', App.cbo04_PROC.getValue(), false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt04_COST_TOTAL"  runat="server" Width="125" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt04_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>                                  
                                </tr>
                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">
                                    </td>                                    
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo05_PROC" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="225">
                                            <Items>                                                
                                                <ext:ListItem Value="BOX조립" Text="BOX조립" />
                                                <ext:ListItem Value="제품적입" Text="제품적입" />
                                                <ext:ListItem Value="격자조립" Text="격자조립" />
                                                <ext:ListItem Value="마무리" Text="마무리" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeProcess(this, true);"></Select>
                                                <Change Handler="ChangeProcess(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo05_CTIME_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="120" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store19" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model19" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="CalcProc(this.getId(), '05', App.cbo01_PROC.getValue(), false);"></Select>--%>
                                                <Change Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(), false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_CV_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(), false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_CV"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_CV_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_MAN_QTY" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(), false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_IMYUL" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_MAN_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_MAN_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_MAN_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt05_MACHINE_NM"  runat="server" Width="95" Cls="inputText"  ReadOnly="false" />
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_MACHINE_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_MACHINE_COST"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_MACHINE_COST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt05_MACHINE_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_MACHINE_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_MACHINE_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:right;">
                                        <ext:NumberField ID="txt05_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '05', App.cbo05_PROC.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt05_COST_TOTAL"  runat="server" Width="125" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt05_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>                                  
                                </tr>                                       
                                <tr style="height:30px;">
                                    <td class="line" style="text-align:center;">
                                    </td>                                    
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo06_PROC" runat="server"  Mode="Local" Editable="true"
                                            DisplayField="NAME" ValueField="ID" TriggerAction="All" Width="225">
                                            <Items>                                                
                                                <ext:ListItem Value="BOX조립" Text="BOX조립" />
                                                <ext:ListItem Value="제품적입" Text="제품적입" />
                                                <ext:ListItem Value="격자조립" Text="격자조립" />
                                                <ext:ListItem Value="마무리" Text="마무리" />                                                
                                            </Items>
                                            <Listeners>
                                                <Select Handler="ChangeProcess(this, true);"></Select>
                                                <Change Handler="ChangeProcess(this, false);"></Change>
                                            </Listeners>
                                        </ext:ComboBox>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:ComboBox ID="cbo06_CTIME_H" runat="server"  Mode="Local" DisplayField="NAME" ValueField="CODE"
                                            TriggerAction="All" Width="120" Editable="true" >
                                                <Store>
                                                    <ext:Store ID="Store20" runat="server">
                                                        <Model>
                                                            <ext:Model ID="Model20" runat="server" IDPropery="CODE">
                                                                <Fields>                                                                                    
                                                                    <ext:ModelField Name="CODE" />
                                                                    <ext:ModelField Name="NAME" />
                                                                </Fields>
                                                            </ext:Model>
                                                        </Model>
                                                    </ext:Store>
                                                </Store>                                                
                                            <Listeners>
                                                <%--<Select Handler="CalcProc(this.getId(), '06', App.cbo01_PROC.getValue(),false);"></Select>--%>
                                                <Change Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(), false);"></Change>
                                            </Listeners>                                                                            
                                        </ext:ComboBox>                                          
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_CV_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_CV"  runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_CV_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_MAN_QTY" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <KeyUp Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(),false);"></KeyUp>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_IMYUL" runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_MAN_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_MAN_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_MAN_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:TextField ID="txt06_MACHINE_NM"  runat="server" Width="95" Cls="inputText"  ReadOnly="false" />
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_MACHINE_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_MACHINE_COST"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_MACHINE_COST_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField> 
                                    </td>
                                    <td class="line" style="text-align:center;">
                                        <ext:NumberField ID="txt06_MACHINE_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(),false);"></Change>
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_MACHINE_COST_TOTAL"  runat="server" Width="95" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_MACHINE_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>
                                    <td class="line" style="text-align:right;">
                                        <ext:NumberField ID="txt06_COST_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">
<%--                                            <Listeners>
                                                <Change Handler="CalcProc(this.getId(), '06', App.cbo06_PROC.getValue(),false);"></Change>
                                            </Listeners>--%>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt06_COST_TOTAL"  runat="server" Width="125" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true">                                                
                                                <CustomConfig>
                                                    <ext:ConfigItem Name="GetValue" Value="#(return this.getRawValue(); )" />        
                                                </CustomConfig>
                                                <Listeners>
                                                    <KeyUp Handler="App.txt06_COST_TOTAL_H.setValue(this.getValue());"></KeyUp>                                                    
                                                </Listeners>
                                        </ext:NumberField>
                                    </td>                                  
                                </tr>                                                             
                                <tr style="height:30px;">
                                    <th colspan="8" class="line" style="text-align:center;font-weight:bold;vertical-align:middle;font-size:15px;">
                                        <ext:Label ID="Label42" runat="server" Text="④ 가 공 비 소 계"/>
                                    </th>
                                    <td colspan="3" class="line" style="text-align:right;font-weight:bold;vertical-align:middle;font-size:15px;padding-right:10px;">
                                        
                                        <ext:NumberField ID="txt01_MANUFATUR_SUM_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_MANUFATUR_SUM"  runat="server" Width="325" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                                                 
                                </tr>
                            </table>
                        </Content>
                    </ext:Panel>

                    <%--4.기타--%>
                    <ext:Label ID="Label36" runat="server" Cls="bottom_area_title_name" Text="기타" />
                    <ext:Panel ID="Panel3" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 70px;" />
                                    <col style="width: 410px;" />                                    
                                    <col style="width: 640px;" />                                    
                                    <col />                                    
                                </colgroup>                                
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label37" runat="server" Text="⑤" />
                                    </th>
                                    <td class="line" style="text-align:left;vertical-align:middle;font-weight:bold;">
                                        <ext:Label ID="Label45" runat="server" Text="일반관리비"/>
                                    </td>                                      
                                    <td class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label47" runat="server" Text="④ x 15%"/>
                                    </td>  
                                    <td class="line">
                                        <ext:NumberField ID="txt01_BASIC_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_BASIC_COST"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                </tr>      
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label43" runat="server" Text="⑥" />
                                    </th>
                                    <td class="line" style="text-align:left;vertical-align:middle;font-weight:bold;">
                                        <ext:Label ID="Label44" runat="server" Text="이      윤"/>
                                    </td>                                      
                                    <td class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label49" runat="server" Text="(④ + ⑤) x 10%"/>
                                    </td>  
                                    <td class="line">
                                        <ext:NumberField ID="txt01_PROFIT_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_PROFIT"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                </tr> 
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label50" runat="server" Text="⑦" />
                                    </th>
                                    <td class="line" style="text-align:left;vertical-align:middle;font-weight:bold;">
                                        <ext:Label ID="Label51" runat="server" Text="재료관리비"/>
                                    </td>                                      
                                    <td class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label53" runat="server" Text="① x 5%"/>
                                    </td>  
                                    <td class="line">
                                        <ext:NumberField ID="txt01_MATERIAL_MANAGE_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_MATERIAL_MANAGE_COST"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                </tr> 
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label54" runat="server" Text="⑧" />
                                    </th>
                                    <td class="line" style="text-align:left;vertical-align:middle;font-weight:bold;">
                                        <ext:Label ID="Label55" runat="server" Text="열  처  리"/>
                                    </td>                                      
                                    <td class="line" style="text-align:center;vertical-align:middle;">
                                        
                                        <ext:FieldContainer ID="FieldContainer15" runat="server" MsgTarget="Side" Flex="1" Width="110" Layout="TableLayout" StyleSpec="text-align:center;vertical-align:middle;margin-left:250px;" >
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_PROC_VALUE"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_PROC_HEAT_H.setValue(this.getValue() * App.txt01_PROC_VALUE2.getValue());App.txt01_PROC_HEAT.setValue(this.getValue() * App.txt01_PROC_VALUE2.getValue());TotalSum();"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label57" runat="server" Text="才	x"/>
                                            <ext:NumberField ID="txt01_PROC_VALUE2"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_PROC_HEAT_H.setValue(this.getValue() * App.txt01_PROC_VALUE.getValue());App.txt01_PROC_HEAT.setValue(this.getValue() * App.txt01_PROC_VALUE.getValue());TotalSum();"></KeyUp>                                                                                                  
                                                </Listeners>
                                            </ext:NumberField>
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>  
                                    <td class="line">
                                        <ext:NumberField ID="txt01_PROC_HEAT_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_PROC_HEAT"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                </tr> 
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label58" runat="server" Text="⑨" />
                                    </th>
                                    <td class="line" style="text-align:left;vertical-align:middle;font-weight:bold;">
                                        <ext:Label ID="Label60" runat="server" Text="STUFFING CHARGE"/>
                                    </td>                           
                                    <td class="line" style="text-align:center;vertical-align:middle;">                                        
                                        <ext:FieldContainer ID="FieldContainer16" runat="server" MsgTarget="Side" Flex="1" Width="110" Layout="TableLayout" StyleSpec="text-align:center;vertical-align:middle;margin-left:250px;" >
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_STUFF_CHARGE_VALUE"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_STUFF_CHARGE_H.setValue(this.getValue() * App.txt01_STUFF_CHARGE_VALUE2.getValue());App.txt01_STUFF_CHARGE.setValue(this.getValue() * App.txt01_STUFF_CHARGE_VALUE2.getValue());TotalSum();"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label128" runat="server" Text="CBM x"/>
                                            <ext:NumberField ID="txt01_STUFF_CHARGE_VALUE2"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_STUFF_CHARGE_H.setValue(this.getValue() * App.txt01_STUFF_CHARGE_VALUE.getValue());App.txt01_STUFF_CHARGE.setValue(this.getValue() * App.txt01_STUFF_CHARGE_VALUE.getValue());TotalSum();"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField>
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>  
                                    <td class="line">
                                        <ext:NumberField ID="txt01_STUFF_CHARGE_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_STUFF_CHARGE"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                </tr> 
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label63" runat="server" Text="⑩" />
                                    </th>
                                    <td class="line" style="text-align:left;vertical-align:middle;font-weight:bold;">
                                        <ext:Label ID="Label64" runat="server" Text=" 중장비 사용료"/>
                                    </td>                                      
                                    <td class="line" style="text-align:center;vertical-align:middle;">                                        
                                        <ext:FieldContainer ID="FieldContainer17" runat="server" MsgTarget="Side" Flex="1" Width="110" Layout="TableLayout" StyleSpec="text-align:center;vertical-align:middle;margin-left:250px;" >
                                            <Items>                                        
                                            <ext:NumberField ID="txt01_USE_MACHINE_VALUE"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_USE_MACHINE_H.setValue(this.getValue() * App.txt01_USE_MACHINE_VALUE2.getValue());App.txt01_USE_MACHINE.setValue(this.getValue() * App.txt01_USE_MACHINE_VALUE2.getValue());TotalSum();"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField>
                                            <ext:Label ID="Label62" runat="server" Text="시간 X"/>
                                            <ext:NumberField ID="txt01_USE_MACHINE_VALUE2"  runat="server" Width="30" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="2" HideTrigger="true" EnableKeyEvents="true">
                                                <Listeners>
                                                    <KeyUp Handler="App.txt01_USE_MACHINE_H.setValue(this.getValue() * App.txt01_USE_MACHINE_VALUE.getValue());App.txt01_USE_MACHINE.setValue(this.getValue() * App.txt01_USE_MACHINE_VALUE.getValue());TotalSum();"></KeyUp>                                                    
                                                </Listeners>
                                            </ext:NumberField>
                                            </Items>
                                        </ext:FieldContainer> 
                                    </td>  
                                    <td class="line">
                                        <ext:NumberField ID="txt01_USE_MACHINE_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_USE_MACHINE"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                </tr> 
                                <tr>
                                    <th class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label67" runat="server" Text="⑪" />
                                    </th>
                                    <td class="line" style="text-align:left;vertical-align:middle;font-weight:bold;">
                                        <ext:Label ID="Label68" runat="server" Text="금형비"/>
                                    </td>                                      
                                    <td class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label70" runat="server" Text=""/>
                                    </td>  
                                    <td class="line">
                                        <ext:NumberField ID="txt01_MOLD_COST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                            <Listeners>
                                                <KeyUp Handler="TotalSum();"></KeyUp>                                                    
                                            </Listeners>
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_MOLD_COST"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="false" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                </tr>                            
                                <tr style="height:50px;" >
                                    <th colspan="3" class="line" style="text-align:center;font-weight:bold;vertical-align:middle;font-size:18px;">
                                        <ext:Label ID="Label59" runat="server" Text="포장비 원가 TOTAL(①+④+⑤+⑥+⑦+⑧+⑨+⑩+⑪)"/>
                                    </th>
                                    <td class="line" style="text-align:right;font-weight:bold;vertical-align:middle;font-size:15px;padding-right:10px;">
                                        <ext:NumberField ID="txt01_PACKING_TOTAL_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_PACKING_TOTAL"  runat="server" Width="172" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                                                 
                                </tr>                                                                
                             </table>
                        </Content>
                    </ext:Panel>                    
                    <%--5.검토--%>
                    <ext:Label ID="Label46" runat="server" Cls="bottom_area_title_name" Text="검토" />
                    <ext:Panel ID="Panel4" Cls="excel_upload_area_table" runat="server" StyleSpec="width:1300px !important;">
                        <Content>
                            <table>
                                <colgroup>
                                    <col style="width: 70px;" />
                                    <col style="width: 200px;" />                                    
                                    <col style="width: 200px;" />                                    
                                    <col style="width: 350px;" />                                    
                                    <col style="width: 150px;" />                                    
                                    <col style="width: 250px;" />                                    
                                    <col />                                    
                                </colgroup>
                                <tr>
                                    <th rowspan="4" class="line" style="text-align:center;vertical-align:middle;font-size:18px;font-weight:bold;">
                                        <ext:Label ID="Label48" runat="server" Text="작" /><br />
                                        <ext:Label ID="Label86" runat="server" Text="성" /><br />
                                        <ext:Label ID="Label87" runat="server" Text="일" />
                                    </th>
                                    <td rowspan="4" class="line" style="text-align:center;vertical-align:middle;font-weight:bold;">
                                        <ext:DateField ID="dte01_WRITE_DATE" Width="195" Cls="inputDate" Type="Date" runat="server" Editable="true"  />
                                    </td>                                      
                                    <th class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label56" runat="server" Text="작 성 자"/>
                                    </th>  
                                    <td class="line" style="text-align:right;vertical-align:middle;padding-right:10px;">
                                        <ext:TextField ID="txt01_WRITER"  runat="server" Width="285"  Cls="inputText"/>                                        
                                    </td>                                      
                                    <th class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label88" runat="server" Text="검토금액(1BOX)"/>
                                    </th>  
                                    <td class="line"">
                                        <ext:NumberField ID="txt01_CHECK_BOXCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_CHECK_BOXCOST"  runat="server" Width="265" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                      
                                    <td rowspan="2" class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label89" runat="server" Text="VAT"/><br />
                                        <ext:Label ID="Label90" runat="server" Text="별도"/>
                                    </td>                                      
                                </tr> 
                                <tr>                                                                                                            
                                    <th rowspan="2" class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label72" runat="server" Text="검  토"/>
                                    </th>  
                                    <td rowspan="2" class="line" style="text-align:right;vertical-align:middle;padding-right:10px;">
                                        <ext:TextField ID="txt01_CHECKER"  runat="server" Width="285"  Cls="inputText"/>
                                    </td>                                      
                                    <th class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label73" runat="server" Text="결정금액(1BOX)"/>
                                    </th>  
                                    <td class="line"">
                                        <ext:NumberField ID="txt01_DECIDED_BOXCOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_DECIDED_BOXCOST"  runat="server" Width="265" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>                                                                          
                                </tr>    
                                <tr>                                     
                                    <th class="line"  class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label65" runat="server" Text="검토금액(1EA)"/>
                                    </th>  
                                    <td class="line" style="text-align:right;vertical-align:middle;padding-right:10px;">
                                        <ext:NumberField ID="txt01_CHECK_EACOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_CHECK_EACOST"  runat="server" Width="265" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;">
                                        </ext:NumberField> 
                                    </td>     
                                    <td rowspan="2" class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label71" runat="server" Text="VAT"/><br />
                                        <ext:Label ID="Label74" runat="server" Text="별도"/>
                                    </td>                                                                                                                                                
                                </tr>
                                <tr>                                                                                                            
                                    <th class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label61" runat="server" Text="승  인"/>
                                    </th>  
                                    <td class="line" style="text-align:right;vertical-align:middle;padding-right:10px;">
                                        <ext:TextField ID="txt01_APPLYER"  runat="server" Width="285"  Cls="inputText"/>
                                    </td>                                      
                                    <th class="line" style="text-align:center;vertical-align:middle;">
                                        <ext:Label ID="Label69" runat="server" Text="결정금액(1EA)"/>
                                    </th>  
                                    <td class="line" >
                                        <ext:NumberField ID="txt01_DECIDED_EACOST_H" Hidden="true" runat="server" Width="75" Cls="inputText_Num" FieldCls="inputText_Num" ReadOnly="true" DecimalPrecision="8" HideTrigger="true" EnableKeyEvents="true">                                            
                                        </ext:NumberField>
                                        <ext:NumberField ID="txt01_DECIDED_EACOST"  runat="server" Width="265" Cls="inputText_Num changeColorYellow" ReadOnly="true" DecimalPrecision="0" HideTrigger="true" EnableKeyEvents="true" StyleSpec="border:0px;" FieldCls="inputText_Num changeColorYellow">
                                        </ext:NumberField> 
                                    </td>                                                                          
                                </tr>                                                                                                    
                            </table>
                        </Content>
                    </ext:Panel>
                </Items>
            </ext:Panel>
        </Items>
    </ext:Viewport>
    </form>
</body>
</html>
