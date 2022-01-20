<template>
  <div>
    <el-dialog
      :title="!dataForm.id ? '新增' : !disabled ? '修改' : '查看'"
      :close-on-click-modal="false"
      :visible.sync="visible">
      <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
               label-width="120px">
        <el-form-item label="活动主题" prop="title">
          <el-input v-model="dataForm.title" :disabled="disabled" placeholder="活动主题"></el-input>
        </el-form-item>
        <el-form-item label="活动内容" prop="content">
          <ueditor v-model="dataForm.content" :disabled="disabled" placeholder="活动内容"
                   @beforeInit="addGoodsButtom"></ueditor>
        </el-form-item>
        <el-form-item label="活动icon" prop="avatar">
          <el-img v-model="dataForm.avatar" :disabled="disabled">
          </el-img>
        </el-form-item>
        <el-form-item label="活动条例图片" prop="itemPicUrl">
          <el-img v-model="dataForm.itemPicUrl" :disabled="disabled">
          </el-img>
        </el-form-item>
        <el-form-item label="子标题" prop="subtitle">
          <el-input v-model="dataForm.subtitle" :disabled="disabled" placeholder="子标题"></el-input>
        </el-form-item>
        <el-form-item label="活动类别" prop="topicCategoryId">
          <el-select v-model="dataForm.topicCategoryId" :disabled="disabled" clearable filterable placeholder="请选择"
                     class="width185">
            <el-option
              v-for="topicCategory in topicCategorys"
              :key="topicCategory.id"
              :label="topicCategory.title"
              :value="topicCategory.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="活动价格" prop="priceInfo">
          <el-input-number v-model="dataForm.priceInfo" :min="0" label="活动价格"></el-input-number>
        </el-form-item>
        <el-form-item label="阅读数" prop="readCount">
          <el-input v-model="dataForm.readCount" :disabled="disabled" placeholder=""></el-input>
        </el-form-item>
        <el-form-item label="场景图片链接" prop="scenePicUrl">
          <el-img v-model="dataForm.scenePicUrl" :disabled="disabled">
          </el-img>
        </el-form-item>
        <!--      <el-form-item label="活动模板Id" prop="topicTemplateId">-->
        <!--        <el-input v-model="dataForm.topicTemplateId" :disabled="disabled" placeholder="活动模板Id"></el-input>-->
        <!--      </el-form-item>-->
        <!--      <el-form-item label="活动标签Id" prop="topicTagId">-->
        <!--        <el-input v-model="dataForm.topicTagId" :disabled="disabled" placeholder="活动标签Id"></el-input>-->
        <!--      </el-form-item>-->
      </el-form>
      <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button v-if="!disabled" type="primary" @click="dataFormSubmit()">确定</el-button>
    </span>
    </el-dialog>
    <el-dialog
      title="选择商品"
      :close-on-click-modal="false"
      :visible.sync="addGoodsVisible">
      <el-form label-width="120px">
        <el-form-item label="选择商品" prop="goodsIds">
          <el-select v-model="goods" value-key="id" clearable filterable placeholder="请选择" style="width: 100%">
            <el-option
              v-for="goods in goodsList"
              :key="goods.id"
              :label="goods.name"
              :value="goods">
            </el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="addGoodsVisible = false">取消</el-button>
        <el-button type="primary" @click="addGoods()">确定</el-button>
      </span>
    </el-dialog>

  </div>
</template>

<script>
export default {
  data () {
    return {
      editor: null,
      disabled: false,
      visible: false,
      addGoodsVisible: false,
      goodsList: [],
      goods: [],
      dataForm: {
        id: 0,
        title: '',
        content: '',
        avatar: '',
        itemPicUrl: '',
        subtitle: '',
        topicCategoryId: '',
        priceInfo: '',
        readCount: '',
        scenePicUrl: '',
        topicTemplateId: '',
        topicTagId: ''
      },
      dataRule: {
        title: [
          {
            required: true,
            message: '活动主题不能为空',
            trigger: 'blur'
          }
        ],
        avatar: [
          {
            required: true,
            message: '活动icon不能为空',
            trigger: 'blur'
          }
        ],
        itemPicUrl: [
          {
            required: true,
            message: '活动条例图片不能为空',
            trigger: 'blur'
          }
        ]
      },
      topicCategorys: []
    }
  },
  created () {
    this.$http({
      url: `/mall/topiccategory/queryAll`,
      method: 'get'
    }).then(({data}) => {
      if (data && data.code === 0) {
        this.topicCategorys = data.list
      }
    })
  },
  methods: {
    addGoods () {
      if (this.goods.listPicUrl) {
        this.editor.execCommand('inserthtml', '<p style="text-align: center;"><img width="200" bindlongtap="goodsDetail" data-url="/pages/goods/goods?id=' + this.goods.id + '" src="' + this.goods.listPicUrl + '"/></p><p style="text-align: center;"><strong>' + this.goods.name + '</strong></p><p style="text-align: center;"><span style="color: rgb(255, 0, 0);"> ' + this.goods.retailPrice + '元起</span><strong><br/></strong></p><p style="text-align: center;color: rgb(191, 191, 191)">长按图片查看详情</p>')
        this.addGoodsVisible = false
      } else {
        this.$message({
          message: '该商品暂未设置图片',
          type: 'error',
          duration: 1500
        })
      }
    },
    addGoodsButtom (editorId) {
      let that = this
      window.UE.registerUI('test-button', function (editor, uiName) {
        that.editor = editor
        // 注册按钮执行时的 command 命令，使用命令默认就会带有回退操作
        editor.registerCommand(uiName, {
          execCommand: function () {
            that.$http({
              url: '/mall/goods/queryAll',
              method: 'get'
            }).then(({data}) => {
              if (data && data.code === 0) {
                that.goodsList = data.list
                that.addGoodsVisible = true
              }
            })
          }
        })

        // 创建一个 button
        var btn = new window.UE.ui.Button({
          // 按钮的名字
          name: uiName,
          // 提示
          title: '添加商品',
          // 需要添加的额外样式，可指定 icon 图标，图标路径参考常见问题 2
          cssRules: 'background-image: url(' + window.SITE_CONFIG.cdnUrl + '/static/ueditor/themes/default/images/addGoods.png) !important;background-size: cover;',
          // 点击时执行的命令
          onclick: function () {
            // 这里可以不用执行命令，做你自己的操作也可
            editor.execCommand(uiName)
          }
        })

        // 当点到编辑内容上时，按钮要做的状态反射
        editor.addListener('selectionchange', function () {
          var state = editor.queryCommandState(uiName)
          if (state === -1) {
            btn.setDisabled(true)
            btn.setChecked(false)
          } else {
            btn.setDisabled(false)
            btn.setChecked(state)
          }
        })

        // 因为你是添加 button，所以需要返回这个 button
        return btn
      }, 0)
    },
    init (id, disabled) {
      this.disabled = disabled
      this.dataForm.id = id || ''
      this.visible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].resetFields()
        if (this.dataForm.id) {
          this.$http({
            url: `/mall/topic/info/${this.dataForm.id}`,
            method: 'get'
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm = data.topic
            }
          })
        }
      })
    },
    // 表单提交
    dataFormSubmit () {
      this.$refs['dataForm']
        .validate((valid) => {
          if (valid) {
            this.$http({
              url: `/mall/topic/${!this.dataForm.id ? 'save' : 'update'}`,
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
