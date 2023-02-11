class DocumentsController < ApplicationController
  before_action :set_document, only: %i[show edit update destroy]

  # GET /documents or /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1 or /documents/1.json
  def show; end

  # GET /documents/new
  def new
    @document = DocumentCreationForm.new
  end

  # GET /documents/1/edit
  def edit; end

  # POST /documents or /documents.json
  def create
    @document = DocumentCreationForm.new(document_params)

    if @document.save
      redirect_to document_url(@document.id), notice: 'Document was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    if @document.update(document_params)
      redirect_to document_url(@document), notice: 'Document was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy

      redirect_to documents_url, notice: 'Document was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:title, :description, :location, :date, :identifier,
                                     :attachment, :tags)
  end
end
