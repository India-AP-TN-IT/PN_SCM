﻿//------------------------------------------------------------------------------
// <auto-generated>
//     이 코드는 도구를 사용하여 생성되었습니다.
//     런타임 버전:4.0.30319.42000
//
//     파일 내용을 변경하면 잘못된 동작이 발생할 수 있으며, 코드를 다시 생성하면
//     이러한 변경 내용이 손실됩니다.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Ax.SRM.WP.POMM0090_Service {
    
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ServiceModel.ServiceContractAttribute(Namespace="http://www.seoyon.com/mm/mes", ConfigurationName="POMM0090_Service.POMM0090_MES_SO")]
    public interface POMM0090_MES_SO {
        
        // CODEGEN: POMM0090_MES_SO 작업이 RPC 또는 문서 래핑이 아니므로 메시지 계약을 생성합니다.
        [System.ServiceModel.OperationContractAttribute(Action="http://sap.com/xi/WebService/soap1.1", ReplyAction="*")]
        [System.ServiceModel.XmlSerializerFormatAttribute(SupportFaults=true)]
        Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SOResponse POMM0090_MES_SO(Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SORequest request);
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.2053.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://www.seoyon.com/mm/mes")]
    public partial class DT_POMM0090_MES : object, System.ComponentModel.INotifyPropertyChanged {
        
        private ReqHeader reqHeaderField;
        
        private DT_POMM0090_MESZMMS0210[] zMMS0210Field;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public ReqHeader ReqHeader {
            get {
                return this.reqHeaderField;
            }
            set {
                this.reqHeaderField = value;
                this.RaisePropertyChanged("ReqHeader");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("ZMMS0210", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public DT_POMM0090_MESZMMS0210[] ZMMS0210 {
            get {
                return this.zMMS0210Field;
            }
            set {
                this.zMMS0210Field = value;
                this.RaisePropertyChanged("ZMMS0210");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.2053.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://www.seoyon.com/mm/Common")]
    public partial class ReqHeader : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string zRoutingCdField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string zRoutingCd {
            get {
                return this.zRoutingCdField;
            }
            set {
                this.zRoutingCdField = value;
                this.RaisePropertyChanged("zRoutingCd");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.2053.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://www.seoyon.com/mm/Common")]
    public partial class ResHeader : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string zResultCdField;
        
        private string zResultMsgField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string zResultCd {
            get {
                return this.zResultCdField;
            }
            set {
                this.zResultCdField = value;
                this.RaisePropertyChanged("zResultCd");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string zResultMsg {
            get {
                return this.zResultMsgField;
            }
            set {
                this.zResultMsgField = value;
                this.RaisePropertyChanged("zResultMsg");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.2053.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace="http://www.seoyon.com/mm/mes")]
    public partial class DT_POMM0090_MES_response : object, System.ComponentModel.INotifyPropertyChanged {
        
        private ResHeader resHeaderField;
        
        private DT_POMM0090_MES_responseZMMS0210[] zMMS0210Field;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public ResHeader ResHeader {
            get {
                return this.resHeaderField;
            }
            set {
                this.resHeaderField = value;
                this.RaisePropertyChanged("ResHeader");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute("ZMMS0210", Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public DT_POMM0090_MES_responseZMMS0210[] ZMMS0210 {
            get {
                return this.zMMS0210Field;
            }
            set {
                this.zMMS0210Field = value;
                this.RaisePropertyChanged("ZMMS0210");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.2053.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, Namespace="http://www.seoyon.com/mm/mes")]
    public partial class DT_POMM0090_MES_responseZMMS0210 : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string bUKRSField;
        
        private string wERKSField;
        
        private string dELI_NOTEField;
        
        private string dELI_NOTE_CNTField;
        
        private string bWARTField;
        
        private string iF_DATEField;
        
        private string iF_TIMEField;
        
        private string zRSLT_SAPField;
        
        private string zMSG_SAPField;
        
        private string zDATE_SAPField;
        
        private string zTIME_SAPField;
        
        private string zDATE_POField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string BUKRS {
            get {
                return this.bUKRSField;
            }
            set {
                this.bUKRSField = value;
                this.RaisePropertyChanged("BUKRS");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string WERKS {
            get {
                return this.wERKSField;
            }
            set {
                this.wERKSField = value;
                this.RaisePropertyChanged("WERKS");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=2)]
        public string DELI_NOTE {
            get {
                return this.dELI_NOTEField;
            }
            set {
                this.dELI_NOTEField = value;
                this.RaisePropertyChanged("DELI_NOTE");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=3)]
        public string DELI_NOTE_CNT {
            get {
                return this.dELI_NOTE_CNTField;
            }
            set {
                this.dELI_NOTE_CNTField = value;
                this.RaisePropertyChanged("DELI_NOTE_CNT");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=4)]
        public string BWART {
            get {
                return this.bWARTField;
            }
            set {
                this.bWARTField = value;
                this.RaisePropertyChanged("BWART");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=5)]
        public string IF_DATE {
            get {
                return this.iF_DATEField;
            }
            set {
                this.iF_DATEField = value;
                this.RaisePropertyChanged("IF_DATE");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=6)]
        public string IF_TIME {
            get {
                return this.iF_TIMEField;
            }
            set {
                this.iF_TIMEField = value;
                this.RaisePropertyChanged("IF_TIME");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=7)]
        public string ZRSLT_SAP {
            get {
                return this.zRSLT_SAPField;
            }
            set {
                this.zRSLT_SAPField = value;
                this.RaisePropertyChanged("ZRSLT_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=8)]
        public string ZMSG_SAP {
            get {
                return this.zMSG_SAPField;
            }
            set {
                this.zMSG_SAPField = value;
                this.RaisePropertyChanged("ZMSG_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=9)]
        public string ZDATE_SAP {
            get {
                return this.zDATE_SAPField;
            }
            set {
                this.zDATE_SAPField = value;
                this.RaisePropertyChanged("ZDATE_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=10)]
        public string ZTIME_SAP {
            get {
                return this.zTIME_SAPField;
            }
            set {
                this.zTIME_SAPField = value;
                this.RaisePropertyChanged("ZTIME_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=11)]
        public string ZDATE_PO {
            get {
                return this.zDATE_POField;
            }
            set {
                this.zDATE_POField = value;
                this.RaisePropertyChanged("ZDATE_PO");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    /// <remarks/>
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.Xml", "4.7.2053.0")]
    [System.SerializableAttribute()]
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType=true, Namespace="http://www.seoyon.com/mm/mes")]
    public partial class DT_POMM0090_MESZMMS0210 : object, System.ComponentModel.INotifyPropertyChanged {
        
        private string bUKRSField;
        
        private string wERKSField;
        
        private string dELI_NOTEField;
        
        private string dELI_NOTE_CNTField;
        
        private string bWARTField;
        
        private string iF_DATEField;
        
        private string iF_TIMEField;
        
        private string bUDATField;
        
        private string mES_DOCField;
        
        private string eBELNField;
        
        private string eBELPField;
        
        private string lIFNRField;
        
        private string lGORTField;
        
        private string mATNRField;
        
        private string tXZ01Field;
        
        private string mENGEField;
        
        private string nMENGEField;
        
        private string mEINSField;
        
        private string eLIKZField;
        
        private string iPNAMField;
        
        private string zRSLT_SAPField;
        
        private string zMSG_SAPField;
        
        private string zDATE_SAPField;
        
        private string zTIME_SAPField;
        
        private string zDATE_POField;
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=0)]
        public string BUKRS {
            get {
                return this.bUKRSField;
            }
            set {
                this.bUKRSField = value;
                this.RaisePropertyChanged("BUKRS");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=1)]
        public string WERKS {
            get {
                return this.wERKSField;
            }
            set {
                this.wERKSField = value;
                this.RaisePropertyChanged("WERKS");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=2)]
        public string DELI_NOTE {
            get {
                return this.dELI_NOTEField;
            }
            set {
                this.dELI_NOTEField = value;
                this.RaisePropertyChanged("DELI_NOTE");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=3)]
        public string DELI_NOTE_CNT {
            get {
                return this.dELI_NOTE_CNTField;
            }
            set {
                this.dELI_NOTE_CNTField = value;
                this.RaisePropertyChanged("DELI_NOTE_CNT");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=4)]
        public string BWART {
            get {
                return this.bWARTField;
            }
            set {
                this.bWARTField = value;
                this.RaisePropertyChanged("BWART");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=5)]
        public string IF_DATE {
            get {
                return this.iF_DATEField;
            }
            set {
                this.iF_DATEField = value;
                this.RaisePropertyChanged("IF_DATE");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=6)]
        public string IF_TIME {
            get {
                return this.iF_TIMEField;
            }
            set {
                this.iF_TIMEField = value;
                this.RaisePropertyChanged("IF_TIME");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=7)]
        public string BUDAT {
            get {
                return this.bUDATField;
            }
            set {
                this.bUDATField = value;
                this.RaisePropertyChanged("BUDAT");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=8)]
        public string MES_DOC {
            get {
                return this.mES_DOCField;
            }
            set {
                this.mES_DOCField = value;
                this.RaisePropertyChanged("MES_DOC");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=9)]
        public string EBELN {
            get {
                return this.eBELNField;
            }
            set {
                this.eBELNField = value;
                this.RaisePropertyChanged("EBELN");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=10)]
        public string EBELP {
            get {
                return this.eBELPField;
            }
            set {
                this.eBELPField = value;
                this.RaisePropertyChanged("EBELP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=11)]
        public string LIFNR {
            get {
                return this.lIFNRField;
            }
            set {
                this.lIFNRField = value;
                this.RaisePropertyChanged("LIFNR");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=12)]
        public string LGORT {
            get {
                return this.lGORTField;
            }
            set {
                this.lGORTField = value;
                this.RaisePropertyChanged("LGORT");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=13)]
        public string MATNR {
            get {
                return this.mATNRField;
            }
            set {
                this.mATNRField = value;
                this.RaisePropertyChanged("MATNR");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=14)]
        public string TXZ01 {
            get {
                return this.tXZ01Field;
            }
            set {
                this.tXZ01Field = value;
                this.RaisePropertyChanged("TXZ01");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=15)]
        public string MENGE {
            get {
                return this.mENGEField;
            }
            set {
                this.mENGEField = value;
                this.RaisePropertyChanged("MENGE");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=16)]
        public string NMENGE {
            get {
                return this.nMENGEField;
            }
            set {
                this.nMENGEField = value;
                this.RaisePropertyChanged("NMENGE");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=17)]
        public string MEINS {
            get {
                return this.mEINSField;
            }
            set {
                this.mEINSField = value;
                this.RaisePropertyChanged("MEINS");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=18)]
        public string ELIKZ {
            get {
                return this.eLIKZField;
            }
            set {
                this.eLIKZField = value;
                this.RaisePropertyChanged("ELIKZ");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=19)]
        public string IPNAM {
            get {
                return this.iPNAMField;
            }
            set {
                this.iPNAMField = value;
                this.RaisePropertyChanged("IPNAM");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=20)]
        public string ZRSLT_SAP {
            get {
                return this.zRSLT_SAPField;
            }
            set {
                this.zRSLT_SAPField = value;
                this.RaisePropertyChanged("ZRSLT_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=21)]
        public string ZMSG_SAP {
            get {
                return this.zMSG_SAPField;
            }
            set {
                this.zMSG_SAPField = value;
                this.RaisePropertyChanged("ZMSG_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=22)]
        public string ZDATE_SAP {
            get {
                return this.zDATE_SAPField;
            }
            set {
                this.zDATE_SAPField = value;
                this.RaisePropertyChanged("ZDATE_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=23)]
        public string ZTIME_SAP {
            get {
                return this.zTIME_SAPField;
            }
            set {
                this.zTIME_SAPField = value;
                this.RaisePropertyChanged("ZTIME_SAP");
            }
        }
        
        /// <remarks/>
        [System.Xml.Serialization.XmlElementAttribute(Form=System.Xml.Schema.XmlSchemaForm.Unqualified, Order=24)]
        public string ZDATE_PO {
            get {
                return this.zDATE_POField;
            }
            set {
                this.zDATE_POField = value;
                this.RaisePropertyChanged("ZDATE_PO");
            }
        }
        
        public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
        
        protected void RaisePropertyChanged(string propertyName) {
            System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
            if ((propertyChanged != null)) {
                propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
            }
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class POMM0090_MES_SORequest {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://www.seoyon.com/mm/mes", Order=0)]
        public Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES MT_POMM0090_MES;
        
        public POMM0090_MES_SORequest() {
        }
        
        public POMM0090_MES_SORequest(Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES MT_POMM0090_MES) {
            this.MT_POMM0090_MES = MT_POMM0090_MES;
        }
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
    [System.ServiceModel.MessageContractAttribute(IsWrapped=false)]
    public partial class POMM0090_MES_SOResponse {
        
        [System.ServiceModel.MessageBodyMemberAttribute(Namespace="http://www.seoyon.com/mm/mes", Order=0)]
        public Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES_response MT_POMM0090_MES_response;
        
        public POMM0090_MES_SOResponse() {
        }
        
        public POMM0090_MES_SOResponse(Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES_response MT_POMM0090_MES_response) {
            this.MT_POMM0090_MES_response = MT_POMM0090_MES_response;
        }
    }
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public interface POMM0090_MES_SOChannel : Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SO, System.ServiceModel.IClientChannel {
    }
    
    [System.Diagnostics.DebuggerStepThroughAttribute()]
    [System.CodeDom.Compiler.GeneratedCodeAttribute("System.ServiceModel", "4.0.0.0")]
    public partial class POMM0090_MES_SOClient : System.ServiceModel.ClientBase<Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SO>, Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SO {
        
        public POMM0090_MES_SOClient() {
        }
        
        public POMM0090_MES_SOClient(string endpointConfigurationName) : 
                base(endpointConfigurationName) {
        }
        
        public POMM0090_MES_SOClient(string endpointConfigurationName, string remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public POMM0090_MES_SOClient(string endpointConfigurationName, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(endpointConfigurationName, remoteAddress) {
        }
        
        public POMM0090_MES_SOClient(System.ServiceModel.Channels.Binding binding, System.ServiceModel.EndpointAddress remoteAddress) : 
                base(binding, remoteAddress) {
        }
        
        [System.ComponentModel.EditorBrowsableAttribute(System.ComponentModel.EditorBrowsableState.Advanced)]
        Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SOResponse Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SO.POMM0090_MES_SO(Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SORequest request) {
            return base.Channel.POMM0090_MES_SO(request);
        }
        
        public Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES_response POMM0090_MES_SO(Ax.SRM.WP.POMM0090_Service.DT_POMM0090_MES MT_POMM0090_MES) {
            Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SORequest inValue = new Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SORequest();
            inValue.MT_POMM0090_MES = MT_POMM0090_MES;
            Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SOResponse retVal = ((Ax.SRM.WP.POMM0090_Service.POMM0090_MES_SO)(this)).POMM0090_MES_SO(inValue);
            return retVal.MT_POMM0090_MES_response;
        }
    }
}
