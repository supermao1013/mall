<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : !disabled ? '修改' : '查看'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" label-width="120px">
      <el-form-item label="订单编号" prop="orderSn">
        <el-input v-model="dataForm.orderSn" disabled placeholder="订单编号"></el-input>
      </el-form-item>
      <el-form-item label="申请人" prop="nickname">
        <el-tag>{{dataForm.nickname + dataForm.mobile}}</el-tag>
      </el-form-item>
      <el-form-item label="退款单编号" prop="saleserviceSn">
        <el-input v-model="dataForm.saleserviceSn" disabled placeholder="退款单编号"></el-input>
      </el-form-item>
      <el-form-item label="申请退款原因" prop="reason">
        <el-input v-model="dataForm.reason" disabled placeholder="申请退款原因"></el-input>
      </el-form-item>
      <el-form-item label="申请时间" prop="createTime">
        <el-date-picker v-model="dataForm.createTime" type="datetime" disabled
                        placeholder="申请时间"></el-date-picker>
      </el-form-item>
      <el-form-item label="审核时间" prop="handleTime">
        <el-date-picker v-model="dataForm.handleTime" type="datetime" disabled
                        placeholder="审核时间"></el-date-picker>
      </el-form-item>
      <el-form-item label="退款时间" prop="refundTime">
        <el-date-picker v-model="dataForm.refundTime" type="datetime" disabled
                        placeholder="退款时间"></el-date-picker>
      </el-form-item>
      <el-form-item label="用户备注" prop="remark">
        <el-input type="textarea" v-model="dataForm.remark" disabled placeholder="用户备注"></el-input>
      </el-form-item>
      <el-form-item label="申请退款金额" prop="amount">
        <el-input-number v-model="dataForm.amount" :disabled="disabled" controls-position="right" :min="0.01"
                         :precision="2"></el-input-number>
      </el-form-item>
      <el-form-item label="状态" prop="status" v-if="disabled">
        <el-radio-group v-model="dataForm.status" :disabled="disabled">
          <el-radio :label="1">已申请</el-radio>
          <el-radio :label="2">已审核</el-radio>
          <el-radio :label="3">已退款</el-radio>
          <el-radio :label="4">已驳回</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="审核原因" prop="handleReason">
        <el-input type="textarea" v-model="dataForm.handleReason" :disabled="disabled" placeholder="审核原因"></el-input>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button v-if="!disabled" type="primary" @click="dataFormSubmit(1)">通过</el-button>
      <el-button v-if="!disabled" type="warning" @click="dataFormSubmit(2)">拒绝</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  data () {
    return {
      disabled: false,
      visible: false,
      dataForm: {
        id: 0,
        orderSn: '',
        userId: '',
        saleserviceSn: '',
        reason: '',
        amount: '',
        status: '',
        createTime: '',
        handleTime: '',
        refundTime: '',
        handleReason: '',
        remark: ''
      },
      dataRule: {
        handleReason: [
          {required: true, message: '审核原因不能为空', trigger: 'blur'}
        ]
      }
    }
  },
  methods: {
    init (id, disabled) {
      this.disabled = disabled
      this.dataForm.id = id || ''
      this.visible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].resetFields()
        if (this.dataForm.id) {
          this.$http({
            url: `/mall/ordersaleservice/info/${this.dataForm.id}`,
            method: 'get'
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm = data.ordersaleservice
            }
          })
        }
      })
    },
    // 表单提交
    dataFormSubmit (type) {
      this.$refs['dataForm']
        .validate((valid) => {
          if (valid) {
            this.$http({
              url: `/mall/ordersaleservice/${type === 1 ? 'adopt' : 'refuse'}`,
              method: 'post',
              data: this.dataForm
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.$message({
                  message: '操作成功',
                  type: 'success',
                  duration: 1500
                })
                this.visible = false
                this.$emit('refreshDataList')
              }
            })
          }
        })
    }
  }
}
</script>
