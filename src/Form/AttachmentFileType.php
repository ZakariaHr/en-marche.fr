<?php

namespace AppBundle\Form;

use AppBundle\Entity\Mooc\AttachmentFile;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\OptionsResolver\OptionsResolver;

class AttachmentFileType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('title', TextType::class, [
                'label' => 'Titre',
                'filter_emojis' => true,
            ])
            ->add('file', FileType::class)
        ;

        $builder->addEventListener(FormEvents::POST_SET_DATA, [$this, 'changeRequiredOptionForFile']);
    }

    public function changeRequiredOptionForFile(FormEvent $formEvent): void
    {
        /** @var AttachmentFile $file */
        $file = $formEvent->getData();

        if ($file && $file->getPath()) {
            $formEvent->getForm()
                ->remove('file')
                ->add('path', TextType::class, [
                    'disabled' => true,
                ])
            ;
        }
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefault('data_class', AttachmentFile::class);
    }
}
