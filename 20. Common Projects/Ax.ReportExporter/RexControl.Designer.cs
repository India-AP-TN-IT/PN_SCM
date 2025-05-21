namespace Ax.ReportExporter
{
    partial class RexControl
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(RexControl));
            this.label1 = new System.Windows.Forms.Label();
            this.axRexViewer = new AxClipsoft.AxRexViewerCtrl30();
            ((System.ComponentModel.ISupportInitialize)(this.axRexViewer)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(136, 12);
            this.label1.TabIndex = 0;
            this.label1.Text = "ReportExporter Window";
            // 
            // axRexViewer
            // 
            this.axRexViewer.Dock = System.Windows.Forms.DockStyle.Fill;
            this.axRexViewer.Enabled = true;
            this.axRexViewer.Location = new System.Drawing.Point(0, 0);
            this.axRexViewer.Name = "axRexViewer";
            this.axRexViewer.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("axRexViewer.OcxState")));
            this.axRexViewer.Size = new System.Drawing.Size(781, 539);
            this.axRexViewer.TabIndex = 1;
            // 
            // RexControl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(781, 539);
            this.Controls.Add(this.axRexViewer);
            this.Controls.Add(this.label1);
            this.Name = "RexControl";
            this.Text = "RexControl";
            this.Load += new System.EventHandler(this.RexControl_Load);
            ((System.ComponentModel.ISupportInitialize)(this.axRexViewer)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private AxClipsoft.AxRexViewerCtrl30 axRexViewer;

    }
}